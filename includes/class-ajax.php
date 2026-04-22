<?php
/**
 * AJAX handlers.
 *
 * @package CookieConsentWPS
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class CCWPS_Ajax {

	private CCWPS_Consent_Log $log;
	private CCWPS_Settings $settings;
	private string $last_mail_error = '';

	public function __construct( CCWPS_Consent_Log $log, CCWPS_Settings $settings ) {
		$this->log      = $log;
		$this->settings = $settings;

		// Public (frontend).
		add_action( 'wp_ajax_ccwps_save_consent',        [ $this, 'save_consent' ] );
		add_action( 'wp_ajax_nopriv_ccwps_save_consent', [ $this, 'save_consent' ] );

		// Admin.
		add_action( 'wp_ajax_ccwps_clear_log',           [ $this, 'clear_log' ] );
		add_action( 'wp_ajax_ccwps_save_settings',       [ $this, 'save_settings' ] );
		add_action( 'wp_ajax_ccwps_save_cookie',         [ $this, 'save_cookie' ] );
		add_action( 'wp_ajax_ccwps_delete_cookie',       [ $this, 'delete_cookie' ] );
		add_action( 'wp_ajax_ccwps_delete_cookies_bulk', [ $this, 'delete_cookies_bulk' ] );
		add_action( 'wp_ajax_ccwps_save_block',          [ $this, 'save_block' ] );
		add_action( 'wp_ajax_ccwps_delete_block',        [ $this, 'delete_block' ] );
		add_action( 'wp_ajax_ccwps_delete_blocks_bulk',  [ $this, 'delete_blocks_bulk' ] );
		add_action( 'wp_ajax_ccwps_reset_settings',      [ $this, 'reset_settings' ] );
		add_action( 'wp_ajax_ccwps_save_admin_lang',     [ $this, 'save_admin_lang' ] );
		add_action( 'wp_ajax_ccwps_request_cookie_preset', [ $this, 'request_cookie_preset' ] );
		add_action( 'wp_ajax_ccwps_get_theme_palette',  [ $this, 'get_theme_palette_colors' ] );
	}

	/* ---- PUBLIC ---- */

	public function save_consent(): void {
		check_ajax_referer( 'ccwps_consent', 'nonce' );

		if ( ! $this->settings->get( 'record_consents' ) ) {
			wp_send_json_success();
		}

		$ip = $this->get_ip();

		$data = [
			'consent_id'  => $this->get_posted_text( 'consent_id' ),
			'url'         => $this->get_posted_url( 'url' ),
			'location'    => $this->get_posted_text( 'location' ),
			'ip_address'  => $ip,
			'user_agent'  => sanitize_textarea_field( $this->get_server_value( 'HTTP_USER_AGENT' ) ),
			'analytics'   => $this->get_posted_int( 'analytics' ),
			'targeting'   => $this->get_posted_int( 'targeting' ),
			'preferences' => $this->get_posted_int( 'preferences' ),
		];

		$this->log->save( $data ) ? wp_send_json_success() : wp_send_json_error( 'Could not save consent.' );
	}

	/* ---- ADMIN ---- */

	public function clear_log(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$this->log->clear_all();
		wp_send_json_success();
	}

	public function save_settings(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );

		$allowed_keys = array_keys( $this->settings->get_all() );
		$color_keys   = [
			'primary_color', 'text_color', 'bg_color', 'btn_text_color',
			'btn_primary_bg', 'btn_primary_bg_hv', 'btn_primary_txt',
			'btn_ghost_bg', 'btn_ghost_bg_hv', 'btn_ghost_txt', 'btn_ghost_txt_hv',
			'btn_outline_bg', 'btn_outline_bg_hv', 'btn_outline_txt', 'btn_outline_border',
			'modal_bg', 'modal_header_bg', 'modal_footer_bg', 'modal_border', 'modal_text',
			'cat_header_bg', 'cat_header_bg_hv', 'toggle_on_color', 'always_on_color',
		];
		$html_keys    = [ 'lang_banner_description', 'lang_necessary_desc', 'lang_analytics_desc', 'lang_targeting_desc', 'lang_preferences_desc' ];

		$posted = $this->get_posted_array( 'settings' );

		if ( isset( $posted['banner_layout'] ) && 'bar' === sanitize_key( (string) $posted['banner_layout'] ) ) {
			$bar_positions = [ 'top-center', 'bottom-center' ];
			$position      = isset( $posted['banner_position'] ) ? sanitize_key( (string) $posted['banner_position'] ) : '';

			$posted['banner_position'] = in_array( $position, $bar_positions, true ) ? $position : 'bottom-center';
		}

		$url_keys = [ 'icon_custom_url', 'banner_logo_url', 'banner_logo_link_url', 'matomo_url' ];
		foreach ( $allowed_keys as $key ) {
			if ( ! array_key_exists( $key, $posted ) ) continue;
			$value = $posted[ $key ];
			if ( in_array( $key, $color_keys, true ) ) {
				$value = ( $value === 'transparent' ) ? 'transparent' : sanitize_hex_color( $value );
			} elseif ( in_array( $key, $url_keys, true ) ) {
				$value = esc_url_raw( $value );
			} elseif ( in_array( $key, $html_keys, true ) ) {
				$value = wp_kses_post( $value );
			} else {
				$value = sanitize_text_field( $value );
			}
			$this->settings->set( $key, $value );
		}

		wp_send_json_success();
	}

	public function save_cookie(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$manager = new CCWPS_Cookie_Manager();
		$id      = $this->get_posted_int( 'id' );
		$data    = [
			'name'        => $this->get_posted_text( 'name' ),
			'domain'      => $this->get_posted_text( 'domain' ),
			'expiration'  => $this->get_posted_text( 'expiration' ),
			'path'        => $this->get_posted_text( 'path', '/' ),
			'description' => $this->get_posted_text( 'description' ),
			'is_regex'    => $this->get_posted_int( 'is_regex' ),
			'category'    => sanitize_key( $this->get_posted_text( 'category', 'necessary' ) ),
		];
		$ok      = $id ? $manager->update( $id, $data ) : (bool) $manager->insert( $data );
		$ok ? wp_send_json_success() : wp_send_json_error( 'Failed to save cookie.' );
	}

	public function delete_cookie(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$id = $this->get_posted_int( 'id' );
		( new CCWPS_Cookie_Manager() )->delete( $id ) ? wp_send_json_success() : wp_send_json_error();
	}

	public function delete_cookies_bulk(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$ids = $this->get_posted_array( 'ids' );
		$ids = array_map( 'intval', $ids );
		if ( empty( $ids ) ) wp_send_json_error();
		$manager = new CCWPS_Cookie_Manager();
		$deleted = 0;
		foreach ( $ids as $id ) {
			if ( $manager->delete( $id ) ) $deleted++;
		}
		$deleted > 0 ? wp_send_json_success() : wp_send_json_error();
	}

	public function save_block(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$manager = new CCWPS_Block_Manager();
		$id      = $this->get_posted_int( 'id' );
		$data    = [
			'script_source' => $this->get_posted_text( 'script_source' ),
			'category'      => sanitize_key( $this->get_posted_text( 'category', 'analytics' ) ),
			'is_regex'      => $this->get_posted_int( 'is_regex' ),
		];
		$ok      = $id ? $manager->update( $id, $data ) : (bool) $manager->insert( $data );
		$ok ? wp_send_json_success() : wp_send_json_error( 'Failed to save rule.' );
	}

	public function delete_blocks_bulk(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$ids = $this->get_posted_array( 'ids' );
		$ids = array_map( 'intval', $ids );
		if ( empty( $ids ) ) wp_send_json_error();
		$manager = new CCWPS_Block_Manager();
		$deleted = 0;
		foreach ( $ids as $id ) {
			if ( $manager->delete( $id ) ) $deleted++;
		}
		$deleted > 0 ? wp_send_json_success() : wp_send_json_error();
	}

	public function delete_block(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		$id = $this->get_posted_int( 'id' );
		( new CCWPS_Block_Manager() )->delete( $id ) ? wp_send_json_success() : wp_send_json_error();
	}

	public function reset_settings(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );
		global $wpdb;
		// phpcs:ignore WordPress.DB.PreparedSQL.NotPrepared,WordPress.DB.DirectDatabaseQuery.DirectQuery,WordPress.DB.DirectDatabaseQuery.NoCaching -- Required wildcard cleanup for plugin options.
		$wpdb->query( "DELETE FROM {$wpdb->options} WHERE option_name LIKE 'ccwps_%' AND option_name != 'ccwps_db_version'" );
		CCWPS_Activator::activate();
		wp_send_json_success();
	}

	public function save_admin_lang(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) wp_die( -1 );

		$lang   = sanitize_key( $this->get_posted_text( 'lang', 'sk' ) );
		$preset = CCWPS_Language_Presets::get( $lang );

		if ( ! $preset ) {
			wp_send_json_error( 'Unknown language.' );
		}

		// Save admin language.
		$this->settings->set( 'admin_lang', $lang );

		// Apply frontend translations.
		$html_keys = [ 'lang_banner_description', 'lang_necessary_desc', 'lang_analytics_desc', 'lang_targeting_desc', 'lang_preferences_desc' ];
		foreach ( $preset['strings'] as $key => $value ) {
			$this->settings->set( $key, in_array( $key, $html_keys, true ) ? wp_kses_post( $value ) : sanitize_text_field( $value ) );
		}

		// Apply admin UI translations (nav labels, preview buttons, etc.).
		if ( ! empty( $preset['admin_strings'] ) ) {
			foreach ( $preset['admin_strings'] as $key => $value ) {
				$this->settings->set( $key, sanitize_text_field( $value ) );
			}
		}

		wp_send_json_success( [ 'redirect' => admin_url( 'admin.php?page=ccwps' ) ] );
	}

	public function request_cookie_preset(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( -1 );
		}

		$honeypot = trim( $this->get_posted_text( 'company' ) );
		if ( '' !== $honeypot ) {
			wp_send_json_error( __( 'Nepodarilo sa odoslať žiadosť. Skúste to znova.', 'cookie-consent-webpixelstudio' ) );
		}

		$email   = sanitize_email( $this->get_posted_text( 'email' ) );
		$subject = trim( sanitize_text_field( $this->get_posted_text( 'subject' ) ) );
		$message = trim( sanitize_textarea_field( $this->get_posted_text( 'message' ) ) );

		if ( ! is_email( $email ) ) {
			wp_send_json_error( __( 'Zadajte platný e-mail.', 'cookie-consent-webpixelstudio' ) );
		}

		$subject_length = function_exists( 'mb_strlen' ) ? mb_strlen( $subject ) : strlen( $subject );
		if ( $subject_length < 3 || $subject_length > 150 ) {
			wp_send_json_error( __( 'Predmet musí mať 3 až 150 znakov.', 'cookie-consent-webpixelstudio' ) );
		}

		$message_length = function_exists( 'mb_strlen' ) ? mb_strlen( $message ) : strlen( $message );
		if ( $message_length < 20 || $message_length > 4000 ) {
			wp_send_json_error( __( 'Text správy musí mať 20 až 4000 znakov.', 'cookie-consent-webpixelstudio' ) );
		}

		$ip = $this->get_ip();
		if ( '' === $ip ) {
			$ip = 'user-' . get_current_user_id();
		}

		$short_key    = 'ccwps_req_preset_10m_' . md5( $ip );
		$cooldown_key = 'ccwps_req_preset_cd_' . md5( $ip );
		$daily_key    = 'ccwps_req_preset_day_' . md5( home_url( '/' ) );

		$short_count = (int) get_transient( $short_key );
		$daily_count = (int) get_transient( $daily_key );
		$cooldown    = (int) get_transient( $cooldown_key );

		if ( $cooldown > 0 ) {
			wp_send_json_error( __( 'Počkajte prosím 30 sekúnd a skúste to znova.', 'cookie-consent-webpixelstudio' ) );
		}

		if ( $short_count >= 3 ) {
			wp_send_json_error( __( 'Dosiahli ste limit 3 žiadostí za 10 minút. Skúste to neskôr.', 'cookie-consent-webpixelstudio' ) );
		}

		if ( $daily_count >= 10 ) {
			wp_send_json_error( __( 'Denný limit žiadostí bol dosiahnutý. Skúste to zajtra.', 'cookie-consent-webpixelstudio' ) );
		}

		$site_url = home_url( '/' );
		$host     = (string) ( wp_parse_url( $site_url, PHP_URL_HOST ) ?: '' );
		$host     = preg_replace( '/[^a-z0-9.-]/i', '', $host );

		$headers = [
			'Content-Type: text/plain; charset=UTF-8',
			'Reply-To: ' . $email,
		];

		global $wp_version;
		$body_lines = [
			'Cookie preset request',
			'=====================',
			'',
			'Website: ' . $site_url,
			'Host: ' . $host,
			'Sender email: ' . $email,
			'Subject: ' . $subject,
			'Submitted at (UTC): ' . gmdate( 'Y-m-d H:i:s' ),
			'IP/Identifier: ' . $ip,
			'Plugin version: ' . CCWPS_VERSION,
			'WordPress version: ' . (string) $wp_version,
			'',
			'Message:',
			$message,
		];

		$mail_subject = '[Cookie Preset Request] ' . $subject;
		$this->last_mail_error = '';
		add_action( 'wp_mail_failed', [ $this, 'capture_wp_mail_failed' ] );
		$sent = wp_mail( 'cookies@wps.sk', $mail_subject, implode( "\n", $body_lines ), $headers );
		remove_action( 'wp_mail_failed', [ $this, 'capture_wp_mail_failed' ] );

		if ( ! $sent ) {
			$this->store_failed_preset_request([
				'email'   => $email,
				'subject' => $subject,
				'message' => $message,
				'site_url' => $site_url,
				'host' => $host,
				'created_at_utc' => gmdate( 'Y-m-d H:i:s' ),
				'error' => $this->last_mail_error,
			]);

			$error_message = __( 'Žiadosť sa nepodarilo odoslať z tohto WordPress webu. Skontrolujte SMTP/mail konfiguráciu hostingu.', 'cookie-consent-webpixelstudio' );
			if ( '' !== $this->last_mail_error ) {
				$error_message .= ' ' . sprintf(
					/* translators: %s = mail transport error */
					__( 'Detail chyby: %s', 'cookie-consent-webpixelstudio' ),
					$this->last_mail_error
				);
			}

			wp_send_json_error( $error_message );
		}

		set_transient( $short_key, $short_count + 1, 10 * MINUTE_IN_SECONDS );
		set_transient( $daily_key, $daily_count + 1, DAY_IN_SECONDS );
		set_transient( $cooldown_key, 30, 30 );

		wp_send_json_success( __( 'Žiadosť bola úspešne odoslaná.', 'cookie-consent-webpixelstudio' ) );
	}

	public function capture_wp_mail_failed( $error ): void {
		if ( is_wp_error( $error ) ) {
			$this->last_mail_error = sanitize_text_field( $error->get_error_message() );
		}
	}

	private function store_failed_preset_request( array $request ): void {
		$option_name = 'ccwps_failed_preset_requests';
		$stored = get_option( $option_name, [] );
		if ( ! is_array( $stored ) ) {
			$stored = [];
		}

		$stored[] = [
			'email' => sanitize_email( (string) ( $request['email'] ?? '' ) ),
			'subject' => sanitize_text_field( (string) ( $request['subject'] ?? '' ) ),
			'message' => sanitize_textarea_field( (string) ( $request['message'] ?? '' ) ),
			'site_url' => esc_url_raw( (string) ( $request['site_url'] ?? '' ) ),
			'host' => sanitize_text_field( (string) ( $request['host'] ?? '' ) ),
			'created_at_utc' => sanitize_text_field( (string) ( $request['created_at_utc'] ?? '' ) ),
			'error' => sanitize_text_field( (string) ( $request['error'] ?? '' ) ),
		];

		if ( count( $stored ) > 20 ) {
			$stored = array_slice( $stored, -20 );
		}

		update_option( $option_name, $stored, false );
	}

	public function get_theme_palette_colors(): void {
		check_ajax_referer( 'ccwps_admin', 'nonce' );
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( -1 );
		}

		$palette = [];

		// 1. Try to get palette from theme.json (Gutenberg / Full Site Editing)
		$theme_json_file = get_template_directory() . '/theme.json';
		if ( file_exists( $theme_json_file ) ) {
			// Read and parse theme.json
			// phpcs:ignore WordPress.WP.AlternativeFunctions.file_get_contents_file_get_contents -- Using built-in WP function when available
			$json_content = function_exists( 'wp_json_file_get_contents' ) 
				? wp_json_file_get_contents( $theme_json_file )
				: json_decode( file_get_contents( $theme_json_file ), true ); // phpcs:ignore

			if ( is_array( $json_content ) && isset( $json_content['settings']['color']['palette'] ) ) {
				$colors = $json_content['settings']['color']['palette'];
				if ( is_array( $colors ) ) {
					foreach ( $colors as $color ) {
						if ( isset( $color['color'] ) && isset( $color['name'] ) ) {
							$palette[] = [
								'color' => sanitize_hex_color( $color['color'] ),
								'name'  => sanitize_text_field( $color['name'] ),
							];
						}
					}
				}
			}
		}

		// 2. If no palette found from theme.json, add a default web-safe palette
		if ( empty( $palette ) ) {
			$palette = [
				[ 'color' => '#000000', 'name' => 'Black' ],
				[ 'color' => '#FFFFFF', 'name' => 'White' ],
				[ 'color' => '#F5F5F5', 'name' => 'Light Gray' ],
				[ 'color' => '#E5E5E5', 'name' => 'Gray' ],
				[ 'color' => '#1a73e8', 'name' => 'Blue' ],
				[ 'color' => '#EA4335', 'name' => 'Red' ],
				[ 'color' => '#FBBC04', 'name' => 'Yellow' ],
				[ 'color' => '#34A853', 'name' => 'Green' ],
				[ 'color' => '#FF6D00', 'name' => 'Orange' ],
				[ 'color' => '#9C27B0', 'name' => 'Purple' ],
			];
		}

		wp_send_json_success( [ 'palette' => $palette ] );
	}

	/* ---- HELPERS ---- */

	private function get_ip(): string {
		$headers = [ 'HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP', 'REMOTE_ADDR' ];
		foreach ( $headers as $h ) {
			$value = $this->get_server_value( $h );
			if ( '' !== $value ) {
				$ip = trim( explode( ',', $value )[0] );
				if ( filter_var( $ip, FILTER_VALIDATE_IP ) ) return $ip;
			}
		}
		return '';
	}

	private function get_posted_text( string $key, string $default = '' ): string {
		// phpcs:disable WordPress.Security.NonceVerification.Missing
		if ( ! isset( $_POST[ $key ] ) || is_array( $_POST[ $key ] ) ) {
			return $default;
		}

		$value = sanitize_text_field( wp_unslash( $_POST[ $key ] ) );
		// phpcs:enable WordPress.Security.NonceVerification.Missing

		return $value;
	}

	private function get_posted_url( string $key, string $default = '' ): string {
		// phpcs:disable WordPress.Security.NonceVerification.Missing
		if ( ! isset( $_POST[ $key ] ) || is_array( $_POST[ $key ] ) ) {
			return $default;
		}

		$value = esc_url_raw( wp_unslash( $_POST[ $key ] ) );
		// phpcs:enable WordPress.Security.NonceVerification.Missing

		return $value;
	}

	private function get_posted_int( string $key, int $default = 0 ): int {
		return (int) $this->get_posted_text( $key, (string) $default );
	}

	private function get_posted_array( string $key ): array {
		// phpcs:disable WordPress.Security.ValidatedSanitizedInput.InputNotSanitized,WordPress.Security.NonceVerification.Missing
		if ( ! isset( $_POST[ $key ] ) || ! is_array( $_POST[ $key ] ) ) {
			return [];
		}

		$value = wp_unslash( $_POST[ $key ] );
		// phpcs:enable WordPress.Security.ValidatedSanitizedInput.InputNotSanitized,WordPress.Security.NonceVerification.Missing

		return $value;
	}

	private function get_server_value( string $key ): string {
		if ( ! isset( $_SERVER[ $key ] ) || is_array( $_SERVER[ $key ] ) ) {
			return '';
		}

		return sanitize_text_field( wp_unslash( $_SERVER[ $key ] ) );
	}
}
