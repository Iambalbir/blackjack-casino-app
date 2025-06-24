export 'package:flutter/material.dart';
export 'dart:async';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:equatable/equatable.dart';
export 'package:flutter/services.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:app/core/utils/bloc_providers/bloc_providers.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:app/main.dart' hide DeviceType, basicLocaleListResolution;
export 'package:shared_preferences/shared_preferences.dart';
export 'package:provider/single_child_widget.dart';
export 'dart:io';
export 'dart:math';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:device_info_plus/device_info_plus.dart';

/*----------------------values -------------------------*/
export 'package:app/core/utils/values/helper_widget.dart';

export 'package:app/core/utils/widgets/dimens.dart';
export 'package:app/core/utils/values/textStyles.dart';
export 'package:app/constants.dart';
export 'package:app/core/utils/assets/app_strings.dart';
export 'package:app/core/utils/widgets/validator.dart';

/*----------------------widgets------------------------------*/
export 'package:app/customWidgets.dart' hide ranks;

export 'package:app/core/utils/widgets/text_view.dart';
export 'package:app/core/utils/widgets/custom_textfield.dart';
export 'package:app/core/utils/assets/image_assets.dart';
export 'package:app/core/utils/widgets/asset_image.dart';
export 'package:app/core/utils/widgets/button_widget.dart';
export 'package:app/core/utils/widgets/toast.dart';
/*--------------------dialogs----------------------------*/
export 'package:app/core/utils/dialogs/bet_dialog.dart';
export 'package:app/core/utils/dialogs/player_turn_dialog.dart';
export 'package:app/core/utils/dialogs/result_dialog.dart';
export 'package:app/core/utils/dialogs/start_dialog.dart';
export 'package:app/core/utils/dialogs/game_mode_dialog.dart';
export 'package:app/core/utils/dialogs/select_betamount_dialog.dart';
export 'package:app/core/utils/dialogs/loose_dialog.dart';
export 'package:app/core/utils/dialogs/winning_dialog.dart';
export 'package:app/core/utils/dialogs/logout_dialog.dart';

/*--------------------fireabse-----------------------------*/

export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_crashlytics/firebase_crashlytics.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

/*-------------------No Internte----------------*/

export 'package:app/app/modules/internet_check/bloc/no_internet_bloc.dart';
export 'package:app/app/modules/internet_check/bloc/no_internet_states.dart';

/*------------------Splash Bloc --------------------*/
export 'package:app/app/modules/splash/bloc/splash_bloc.dart';
export 'package:app/app/modules/splash/bloc/splash_event.dart';
export 'package:app/app/modules/splash/bloc/splash_state.dart';

/*--------------------Login bloc------------------------*/

export 'package:app/app/modules/authentication/bloc/login_bloc/login_events.dart';
export 'package:app/app/modules/authentication/bloc/login_bloc/login_states.dart';
export 'package:app/app/modules/authentication/bloc/register_bloc/register_bloc.dart';
export 'package:app/app/modules/main/main_bloc/main_bloc.dart';

/*--------------------routes----------------------------*/
export 'package:app/routes/route_name.dart';
export 'package:app/routes/routes.dart';
export 'package:app/app/modules/splash/screen/splash_screen.dart';
export 'app/modules/games/screens/play_blackjack_screen.dart';
export 'package:app/app/modules/authentication/screens/login_screen.dart';
export 'package:app/app/modules/settings/screen/settings_screen.dart';
export 'package:app/app/modules/games/screens/slot_machine_game_screen.dart';
export 'package:app/app/modules/main/views/main_screen.dart';
export 'package:app/app/modules/leaderboard/screen/leaderboard_screen.dart';
export 'package:app/app/modules/lobby/screen/lobby_access_screen.dart';
export 'package:app/app/modules/wallet/screens/wallet_screen.dart';
export 'package:app/app/modules/invitations/screens/invitation_screen.dart';
export 'package:app/app/modules/lobby/screen/private_room_create_screen.dart';
export 'package:app/app/modules/lobby/screen/waiting_room_screen.dart';
export 'package:app/app/modules/games/screens/active_games.dart';
export 'package:app/app/modules/games/screens/multiplayer_screen.dart';
export 'package:app/app/modules/lobby/screen/public_room_create_screen.dart';
export 'package:app/app/modules/authentication/screens/register_screen.dart';
export 'package:app/app/modules/lobby/screen/public_lobby_listing_screen.dart';
export 'package:app/app/modules/internet_check/view/no_internet_screen.dart';
export 'package:app/core/utils/values/custom_page_route.dart';
/*---------------------Login------------------------*/
export 'package:app/app/modules/authentication/firebase_auth_gate/firebase_auth_gate.dart';
export 'package:app/app/modules/authentication/bloc/login_bloc/login_bloc.dart';

/*----------------register--------------------------*/

export 'package:app/app/modules/authentication/bloc/register_bloc/register_event.dart';
export 'package:app/app/modules/authentication/bloc/register_bloc/register_state.dart';

/*---------------remote-------------------------------*/
export 'package:app/data/remote_service/firebase_service_provider.dart';

/*-------------------------models-----------------------------------*/
export 'package:app/app/modules/authentication/model/request_model/auth_request_model.dart';
export 'package:app/data/model/data_model/current_user_data_model.dart';

/*--------------------------settings bloc----------------------------*/
export 'package:app/app/modules/settings/setting_bloc/settings_bloc.dart';
export 'package:app/app/modules/settings/setting_bloc/settings_event.dart';
export 'package:app/app/modules/settings/setting_bloc/settings_state.dart';

/*---------------------games bloc-------------------------*/
export 'package:app/app/modules/games/bloc/gameController.dart';
export 'package:app/app/modules/games/bloc/gameEvents.dart';
export 'package:app/app/modules/games/bloc/slot_machine_bloc/slotmachine_event.dart';
export 'package:app/app/modules/games/bloc/slot_machine_bloc/slotmachine_state.dart';
export 'package:app/app/modules/games/bloc/slot_machine_bloc/slotmachine_bloc.dart';
export 'package:app/app/modules/games/bloc/blackjack_multi_player_bloc/multiplayer_blackjack_event.dart';
export 'package:app/app/modules/games/bloc/blackjack_multi_player_bloc/multiplayer_blackjack_states.dart';
export 'package:app/app/modules/games/bloc/blackjack_multi_player_bloc/multiplayer_blackjack_bloc.dart';
export 'package:app/app/modules/games/bloc/poker_game_bloc/poker_events.dart';
export 'package:app/app/modules/games/bloc/poker_game_bloc/poker_states.dart';
export 'package:app/app/modules/games/bloc/poker_game_bloc/poker_bloc.dart';

/*-----------------------room bloc --------------------------------*/
export 'package:app/app/modules/lobby/bloc/private_room_bloc/private_room_bloc.dart';
export 'package:app/app/modules/lobby/bloc/private_room_bloc/private_room_event.dart';
export 'package:app/app/modules/lobby/bloc/private_room_bloc/private_room_state.dart';
export 'package:app/app/modules/lobby/bloc/waiting_room_bloc/waiting_room_bloc.dart';
export 'package:app/app/modules/lobby/bloc/waiting_room_bloc/waiting_room_event.dart';
export 'package:app/app/modules/lobby/bloc/waiting_room_bloc/waiting_room_state.dart';
export 'package:app/app/modules/invitations/invitation_bloc/invitation_events.dart';
export 'package:app/app/modules/invitations/invitation_bloc/invitation_state.dart';
export 'package:app/app/modules/invitations/invitation_bloc/invitation_bloc.dart';
export 'package:app/app/modules/lobby/bloc/public_room_bloc/public_room_event.dart';
export 'package:app/app/modules/lobby/bloc/public_room_bloc/public_room_state.dart';
export 'package:app/app/modules/lobby/bloc/public_room_bloc/public_room_bloc.dart';
export 'package:app/app/modules/lobby/bloc/public_lobby_listing_bloc/public_lobby_bloc.dart';
export 'package:app/app/modules/lobby/bloc/public_lobby_listing_bloc/public_lobby_event.dart';
export 'package:app/app/modules/lobby/bloc/public_lobby_listing_bloc/public_lobby_state.dart';

/*----------------------------------- Wallet ----------------------------*/
export 'package:app/app/modules/wallet/bloc/add_coin_bloc/add_coin_bloc.dart';
export 'package:app/app/modules/wallet/bloc/add_coin_bloc/add_coin_state.dart';
export 'package:app/app/modules/wallet/bloc/add_coin_bloc/add_coin_event.dart';
