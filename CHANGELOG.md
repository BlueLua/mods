# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0](https://github.com/BlueLua/mods/compare/v0.6.0...v1.0.0) (2026-06-13)


### ⚠ BREAKING CHANGES

* rename stringcase.capital to stringcase.capitalize
* rename stringcase.swap to stringcase.swapcase
* rename stringcase.replace to stringcase.delimit
* rename tbl.pairmap to tbl.map
* remove tbl.map
* remove str.rindex
* rename repr to stringify
* rename Set to set
* rename List to list

### Features

* add date ([893e091](https://github.com/BlueLua/mods/commit/893e091de2748790f9524b6b7b80aae8810ea3f4))
* add date-duration helper ([4dff673](https://github.com/BlueLua/mods/commit/4dff67390c324dc0eddc73ed9f0aa650ee886c20))
* add duration ([b494976](https://github.com/BlueLua/mods/commit/b49497618c7dc473cf54efbc2a0d25ae690f4fe0))
* **calendar:** add calendar module ([9bf2d82](https://github.com/BlueLua/mods/commit/9bf2d82c38346b490223ed13f6387df6097d7908))
* **calendar:** add monthdays iterator ([76ac6f9](https://github.com/BlueLua/mods/commit/76ac6f9c80fca8f80959c4eaa05db0de891ce5ed))
* **calendar:** expose module from mods entrypoint ([797a8f0](https://github.com/BlueLua/mods/commit/797a8f0024f0b12d36d891c2d12abbec2b65409d))
* **compat:** add global compat shims ([7e8d773](https://github.com/BlueLua/mods/commit/7e8d77394400860aaa00ba3e7198367f64c86aa2))
* **compat:** add loadfile ([69cec70](https://github.com/BlueLua/mods/commit/69cec70d0f0edfd96a1acac7f2ab8ace161241d5))
* **compat:** add table.move shim ([c25a88b](https://github.com/BlueLua/mods/commit/c25a88bb4fa8b32b8ca24378fa4e3ff5f7c58cef))
* **compat:** add xpcall ([c31c917](https://github.com/BlueLua/mods/commit/c31c9170b15957dfbb8793cf6f0f8f412672de9c))
* **export:** show field types in generated module docs ([6a6c40d](https://github.com/BlueLua/mods/commit/6a6c40dce821d8ba1498a10a1bf611b9a7fb8552))
* expose _VERSION ([1a8dd3f](https://github.com/BlueLua/mods/commit/1a8dd3f35047edbdc57b576d4e6bf72ac65063c3))
* **fs:** add cd helper ([ae07571](https://github.com/BlueLua/mods/commit/ae07571a5186a2f7fe2341ecc7344dbd7bf29a41))
* **fs:** add cwd helper ([9f45ced](https://github.com/BlueLua/mods/commit/9f45ced99a0695207a80d5bf326f71e4cf73fe60))
* **fs:** add link and symlink helpers ([7580873](https://github.com/BlueLua/mods/commit/758087398c4a25fcb9c88f5e6c115dd978cca425))
* **fs:** add names option to listdir ([0b6fcb3](https://github.com/BlueLua/mods/commit/0b6fcb3cf59242998b9c742af2c6732b2a2111cf))
* **glob:** add filter helper ([1cd9134](https://github.com/BlueLua/mods/commit/1cd913499265663a977850b61b0e45de69a91f1b))
* **glob:** add glob module ([1c77a48](https://github.com/BlueLua/mods/commit/1c77a4887fc4edefa716e1b8a1fbb81f6150fac9))
* **glob:** support ignorecase in match ([9da7bf7](https://github.com/BlueLua/mods/commit/9da7bf7d228f5c7a3bfcc9f02ce703e77747f463))
* **json:** add JSON encode/decode module ([539b8d1](https://github.com/BlueLua/mods/commit/539b8d16fed8e4d5cfcad113085a88e943654951))
* **keyword:** add Lua 5.5 global keyword ([5b63659](https://github.com/BlueLua/mods/commit/5b63659728bc75a689e8e77b4797f96d524b6f16))
* **List:** add mirror method ([c1084ad](https://github.com/BlueLua/mods/commit/c1084ad50b81ffeb56451f9fe0d176aadcdab7b2))
* **List:** add shuffle ([709ec67](https://github.com/BlueLua/mods/commit/709ec675aeb4ef962e222d887e41c3fdd85a4d3f))
* **list:** support _tolist conversions ([194e0f2](https://github.com/BlueLua/mods/commit/194e0f2b493c8825dc2174448cd274a7ab55b836))
* **log:** add logger module ([a6e5f30](https://github.com/BlueLua/mods/commit/a6e5f3039cfce1d9ad553d54575e9c814f40d475))
* **repr:** add replacers and spacing options ([418a54e](https://github.com/BlueLua/mods/commit/418a54e4006415f32e87b145cdbaced654de7037))
* **runtime:** add Lua 5.5 detection ([89b626a](https://github.com/BlueLua/mods/commit/89b626aa9ac45446d718bffb308baa1e3c7e115c))
* **set:** add has ([4ac06b4](https://github.com/BlueLua/mods/commit/4ac06b48a6524c9c9cc442ed7ddbcba9e0ff0100))
* **Set:** add mirror method ([5399db6](https://github.com/BlueLua/mods/commit/5399db6b96fb2c06a5dca8a99db60f784fa65af8))
* **set:** support _toset conversions ([2696dce](https://github.com/BlueLua/mods/commit/2696dcef455ba7bea8ed9beac251a656fbd91646))
* **stringify:** add opts table, newline, and omit_array_keys ([2c8fcb8](https://github.com/BlueLua/mods/commit/2c8fcb8a569b943909246872f6d4d7a555e02279))
* **tbl:** add deep_equal ([3974857](https://github.com/BlueLua/mods/commit/397485722b3c8c671ec956bb11e5e0faa79c315a))


### Bug Fixes

* **docs:** override vite to patched 6.4.2 ([a310044](https://github.com/BlueLua/mods/commit/a31004437ba73e8a739e2f039710d19f82ffe2f5))
* **fs:** reject non-directory paths in recursive rm ([37db8bd](https://github.com/BlueLua/mods/commit/37db8bd3d5ad31689842ba95d749b9eaa2bb2c92))
* **fs:** samefile fallback and early path checks for dir ([ae99f3b](https://github.com/BlueLua/mods/commit/ae99f3ba2ced801ce35dd4c7aaedb73a88d57254))
* **fs:** use rmdir for directory removal on Windows ([8e29672](https://github.com/BlueLua/mods/commit/8e29672236c102b8a42ef4d09b3bb4b72aae85c1))
* **fs:** validate directory before listing on Windows ([5668d97](https://github.com/BlueLua/mods/commit/5668d97c5e8d29265d6d151272bc4d974a37b7d4))
* **fs:** validate directory path in dir() on Windows ([cce1654](https://github.com/BlueLua/mods/commit/cce1654b187b7cb965d7920c03630793ebe3049d))
* **glob:** avoid backslash path separator in recursive prefix ([f22e31d](https://github.com/BlueLua/mods/commit/f22e31d466baeb0b46f90f8ad3cce74676cbd169))
* preserve original error message on missing submodule ([64256a0](https://github.com/BlueLua/mods/commit/64256a006f0fba420f16a5a91ccbca0e51bd5d12))
* **set:** use rawget for membership ([575a563](https://github.com/BlueLua/mods/commit/575a5636bdf8532605cbf9d5f13b491d1cfe278d))
* **test:** resolve list and set assertions lazily ([f5f6603](https://github.com/BlueLua/mods/commit/f5f66031ae3b7bb57e478331ed8f2fcac58012d4))
* **utils:** return empty string for nil args_repr ([80d177a](https://github.com/BlueLua/mods/commit/80d177ade020c99ae0227e350b7d2ee05b7fcabd))


### Code Refactoring

* remove str.rindex ([fc40828](https://github.com/BlueLua/mods/commit/fc40828db911cce9d5f755300bb5dd07b24afabf))
* remove tbl.map ([b63d1d5](https://github.com/BlueLua/mods/commit/b63d1d5004f1cc4d7b9f0d5667c69856cd639fb5))
* rename List to list ([084f9d1](https://github.com/BlueLua/mods/commit/084f9d13dea12ef405f403aa069169d2d0403d96))
* rename repr to stringify ([54ae553](https://github.com/BlueLua/mods/commit/54ae553e959202783489ef66bfa17fcacf046292))
* rename Set to set ([bf057a8](https://github.com/BlueLua/mods/commit/bf057a839f07aa40c28352468f4722a720e98f52))
* rename stringcase.capital to stringcase.capitalize ([ae629d4](https://github.com/BlueLua/mods/commit/ae629d4dce43fb751c1fa3022b581ceaeaa3841a))
* rename stringcase.replace to stringcase.delimit ([a50af41](https://github.com/BlueLua/mods/commit/a50af41b496e57bb9bd0fc8a2e0248c5858ed597))
* rename stringcase.swap to stringcase.swapcase ([e32f124](https://github.com/BlueLua/mods/commit/e32f1245249a6661b1eba293eefb3ecda58eb9f6))
* rename tbl.pairmap to tbl.map ([5aefaa6](https://github.com/BlueLua/mods/commit/5aefaa698f332a2ad28e9bbd7240fd05f93c2c39))

## [0.6.0](https://github.com/luamod/mods/compare/v0.5.0...v0.6.0) (2026-03-23)


### Features

* **fs:** add cp helper ([048fe8d](https://github.com/luamod/mods/commit/048fe8dabccbfa8e4429ab1e87ccfd5d99542731))
* **fs:** add dir ([e6e070b](https://github.com/luamod/mods/commit/e6e070b03be2dd1df9d1ba641a832c522fd2d306))
* **fs:** add exists and lexists ([afd2775](https://github.com/luamod/mods/commit/afd27751e0284041c6884eab4429ada2d9803572))
* **fs:** add listdir ([2d053bc](https://github.com/luamod/mods/commit/2d053bcc731e2e9955a95057bf04888eba52d027))
* **fs:** add metadata helpers and samefile ([26bb07f](https://github.com/luamod/mods/commit/26bb07fdb713fe7f6df97d29823757a9255574fc))
* **fs:** add mkdir support ([a88b827](https://github.com/luamod/mods/commit/a88b827187980bc81a1e196be1200ad78317071f))
* **fs:** add read_bytes and read_text ([3a661ae](https://github.com/luamod/mods/commit/3a661aef288b2d479b112c7e1a527681e37effae))
* **fs:** add recursive rm ([2611310](https://github.com/luamod/mods/commit/2611310885e722248cda9e2e0e453c66926ecd92))
* **fs:** add touch ([0e064f1](https://github.com/luamod/mods/commit/0e064f18ae4e6bad20c339f252bba5ebaab8fe3a))
* **fs:** add write helpers and rename ([f3b04d5](https://github.com/luamod/mods/commit/f3b04d5fb1e8070f64976fb62677c31fb2a9f706))
* **is:** add path predicate ([a9412ac](https://github.com/luamod/mods/commit/a9412ac038e8354f66dcd69731ca962535680073))
* **List:** add isempty method ([efb3509](https://github.com/luamod/mods/commit/efb3509307ae52575044fa4835b1073430f2b555))
* **list:** support Set inputs ([c23c58d](https://github.com/luamod/mods/commit/c23c58dbfaf736cea93cfae13a491be804c0f65f))
* **path:** add as_uri ([e088435](https://github.com/luamod/mods/commit/e08843585f7a196c59b909de19e21dafa047e42b))
* **path:** add commonprefix ([434c787](https://github.com/luamod/mods/commit/434c787c5d7ca8598f346414004b1e92dabdfb4c))
* **path:** add cwd ([bfbbdc4](https://github.com/luamod/mods/commit/bfbbdc479497059c4f201da543830cb3720090ec))
* **path:** add expandvars ([c537b77](https://github.com/luamod/mods/commit/c537b77e2a756b78293d1fe78a477367805488de))
* **path:** add from_uri ([6307699](https://github.com/luamod/mods/commit/6307699b98076a6b01d3d719d46eb128473b1cc6))
* **path:** add pathlib-style helpers and tests ([1f8c8aa](https://github.com/luamod/mods/commit/1f8c8aae6ba91b60eb8ecd9461ad08bfef748ecc))
* **Set:** accept List in set operations ([938922d](https://github.com/luamod/mods/commit/938922dff63d1fd39e3dae91abbc20de817a0655))
* **Set:** add join/tostring methods ([5ba94d4](https://github.com/luamod/mods/commit/5ba94d442801452a197e38d9691e124028912f4e))
* **tbl:** add foreach ([338885a](https://github.com/luamod/mods/commit/338885a61529fef607331b7a32a5b2c31c64ea29))
* **tbl:** add spairs ([d71a560](https://github.com/luamod/mods/commit/d71a560ff7e6f49ea47f6f1414253d71144a797c))
* **utils:** add lazy_module helper ([34fff2e](https://github.com/luamod/mods/commit/34fff2e7c078c50f1cc7ddcbec24507a03646f26))
* **utils:** add list_args ([237cba0](https://github.com/luamod/mods/commit/237cba0e1f4af532f473381138ef1fcf0fe42982))
* **utils:** add validate ([d5a4fb9](https://github.com/luamod/mods/commit/d5a4fb9133eb13ff48f9baccd16a003ff73bb1a9))
* **utils:** allow table labels in validate ([62a9c20](https://github.com/luamod/mods/commit/62a9c20693cce5b93cbfbdda596f2a51241f2501))
* **utils:** lazy-load lfs on first access ([ee5a52e](https://github.com/luamod/mods/commit/ee5a52eba7c9bd835b30a50b3435049cc5f1d497))
* **utils:** support callable lazy modules ([2566673](https://github.com/luamod/mods/commit/2566673155d62e784ed629ece8a7c056c129129a))
* **utils:** support function lazy modules ([e390768](https://github.com/luamod/mods/commit/e3907681fd4d3320d11ad1b3728693408062a828))
* **validate:** add path validator ([26dc408](https://github.com/luamod/mods/commit/26dc40887ee1ff26637241298035c6669914f6cc))
* **validate:** validate template message ([16c29ca](https://github.com/luamod/mods/commit/16c29ca8a5a43996d2b826e588c799a253994bcc))


### Bug Fixes

* **docs:** override esbuild to patched version ([64fa37f](https://github.com/luamod/mods/commit/64fa37ff815f1af3df4f270988f4f3aeead3277e))
* **List:** detect mods.Set metatable ([c53d656](https://github.com/luamod/mods/commit/c53d656c1214cffe6aae92fde44ae50593f2994b))
* **path:** avoid shadowed str ([ca170e9](https://github.com/luamod/mods/commit/ca170e910ba160b0a98d4adb583e3f818bd0dcf1))
* **path:** handle cwd errors in abspath ([15bcfd1](https://github.com/luamod/mods/commit/15bcfd13d8181d14ddfccb2d6aee8039bc2e4287))
* **path:** return nil errors for relpath/commonpath ([d6d4307](https://github.com/luamod/mods/commit/d6d4307c9675d8d6b545d4cc847272a2de4f3ee0))
* **Set:** accept plain tables as set arguments ([b9fe381](https://github.com/luamod/mods/commit/b9fe381ad096fdb7e2b073d130c3b1adaf946d84))
* **tbl:** stop spairs at end ([016620b](https://github.com/luamod/mods/commit/016620b197a8b5df112632ea3974446ebcb07904))
* **utils:** ignore unknown caller names ([50a18ff](https://github.com/luamod/mods/commit/50a18ffd9026417ec97a98f05f78a1819eef0c4a))
* **validate:** align error wording with Lua ([20f5ae6](https://github.com/luamod/mods/commit/20f5ae63037d2b0d94913345106185bd027964f8))


### Performance Improvements

* **utils:** cache debug.getinfo ([2d10488](https://github.com/luamod/mods/commit/2d10488666c4732fa6e41ac4d5b8036a82828aad))

## [0.5.0](https://github.com/luamod/mods/compare/v0.4.0...v0.5.0) (2026-03-08)


### Features

* **fs:** add filesystem module and helpers ([99f9d46](https://github.com/luamod/mods/commit/99f9d4611d5be4f9c74123f1ddc6a0c5115f84ce))
* **mods:** expose fs module ([ed61252](https://github.com/luamod/mods/commit/ed612522924affa6f339c0e204571f804ae09cf8))
* **ntpath:** add ntpath module ([d58b6eb](https://github.com/luamod/mods/commit/d58b6ebe4f8e8ec793cf57e256f48e0a75a471e7))
* **path:** add home and improve expanduser errors ([5c1c5eb](https://github.com/luamod/mods/commit/5c1c5eb4f33f2416f268e0f2e0901cc1fce4a84f))
* **path:** add shared _splitext helper module ([d89f172](https://github.com/luamod/mods/commit/d89f172207c39c0843c23b88896e0f9195103b26))
* **path:** expose path modules ([05f176f](https://github.com/luamod/mods/commit/05f176f2e290de382b1d1bfc84bf6d6556635ad0))
* **posixpath:** add lexical posix path module ([909b137](https://github.com/luamod/mods/commit/909b137c73e709bb1e6051c09776535aa9c27bdb))
* **runtime:** add is_windows host flag ([bbdc895](https://github.com/luamod/mods/commit/bbdc89509feb07fa1cc3cd5d48ad5866a0ae7788))
* **utils:** add assert_arg helper ([9633b25](https://github.com/luamod/mods/commit/9633b258b63a22351b2313653b7068dcf99c632d))


### Bug Fixes

* **docs:** support include fragments in export ([6c2160e](https://github.com/luamod/mods/commit/6c2160ecb52c0fdbac504ea046635c65a7ad1618))
* **posixpath:** return empty string for empty commonpath input ([e841e73](https://github.com/luamod/mods/commit/e841e7377d891504c22a700afda9cb9832c17d96))
* **utils:** derive assert_arg caller from error level ([57f6977](https://github.com/luamod/mods/commit/57f6977069e1f89595eb4b9fcb06778bbe837902))

## [0.4.0](https://github.com/luamod/mods/compare/v0.3.0...v0.4.0) (2026-03-02)


### Features

* **fs:** add internal filesystem helper module ([#8](https://github.com/luamod/mods/issues/8)) ([1c13573](https://github.com/luamod/mods/commit/1c13573e322b0c2ab3b4617cdba99ab3369adb95))
* **keyword:** add keyword module with docs, types, and tests ([#6](https://github.com/luamod/mods/issues/6)) ([d0103c1](https://github.com/luamod/mods/commit/d0103c1d11fd62b57f4b0a5d3ae8060a7ac9eb4d))
* **List:** add and document __add operator behavior ([44420a5](https://github.com/luamod/mods/commit/44420a58d4e13dcdfca52e969141014c3f2e6405))
* **List:** add equals method and __eq metamethod ([f5099fe](https://github.com/luamod/mods/commit/f5099fe8e781228c0bf47d67aafb42618d32983c))
* **List:** add keypath() method ([08f15d8](https://github.com/luamod/mods/commit/08f15d8d47742d107e2f09ba62605ae8326b38a4))
* **List:** add lexicographic lt/le comparisons ([967dd74](https://github.com/luamod/mods/commit/967dd74a81ee4b006ca3eaaffdd16183623e3e23))
* **List:** add mul method and __mul operator ([a24d77b](https://github.com/luamod/mods/commit/a24d77b71624c96647c8ee3009c7db4bf261a28b))
* **List:** add native concat method ([3110103](https://github.com/luamod/mods/commit/31101037669599ccd1fced988c4c5642501f053f))
* **List:** add optional quoted mode to join ([a095afb](https://github.com/luamod/mods/commit/a095afb6524d7dbee1bd739699279ebcc7acf4fb))
* **List:** add tostring method and metamethod ([94f8516](https://github.com/luamod/mods/commit/94f8516be17549799b0214175708e82899a8b028))
* **List:** make join stringify values safely ([fb89a80](https://github.com/luamod/mods/commit/fb89a809755cc4c9140634227fed6b7c667cc7fa))
* **List:** support subtraction operator for difference ([211bc1a](https://github.com/luamod/mods/commit/211bc1adde5c977712e9dd934d5fc5b766ba065b))
* **repr:** add repr module ([#7](https://github.com/luamod/mods/issues/7)) ([da6bcec](https://github.com/luamod/mods/commit/da6bcec36eb0e0c4980e45944d0271a58a56bbb7))
* **runtime:** add runtime metadata module ([dd38008](https://github.com/luamod/mods/commit/dd38008dc191343148a2a33ac5f5211721030d40))
* **Set:** add __add metamethod for union ([60c989e](https://github.com/luamod/mods/commit/60c989e76578533cfb77e0c5312e08673f857335))
* **Set:** add __lt and __le subset comparisons ([bc77e7f](https://github.com/luamod/mods/commit/bc77e7ffb4e2e5832cb3b3ec3b31b2580ff699a9))
* **Set:** add __sub metamethod for difference ([347300f](https://github.com/luamod/mods/commit/347300fa2d90acf7fb8ea1130ff368d8102dfe8e))
* **Set:** add & operator for intersection ([b22cc21](https://github.com/luamod/mods/commit/b22cc214797dd274d0d6a71426cf93d38a465084))
* **Set:** add ^ operator for symmetric difference ([3a9b379](https://github.com/luamod/mods/commit/3a9b3790b930e52bb2311bf61e7c35b683eb3ba9))
* **Set:** add | operator for union ([9478734](https://github.com/luamod/mods/commit/9478734b485e142eab1c12bed883f4f2c310b66c))
* **Set:** add contains method ([b11f050](https://github.com/luamod/mods/commit/b11f0502fe7a47787a16401330c45735d95735bd))
* **Set:** add equality method and __eq metamethod ([f51af8d](https://github.com/luamod/mods/commit/f51af8df943d4c8ecc25166dbf3617c36c490c2e))
* **tbl:** add keypath() function ([4b2f590](https://github.com/luamod/mods/commit/4b2f590e352d0921dace1482a08eff195ce8e30f))
* **tbl:** add same function ([c8e0c55](https://github.com/luamod/mods/commit/c8e0c556c58431f4834bbdb52978a06ff830c557))
* **utils:** add lazy repr resolver with inspect fallback ([aec7f60](https://github.com/luamod/mods/commit/aec7f60c15534b66d62aac70c597ab0baa0e1725))


### Bug Fixes

* **is:** add __index for case-insensitive type lookups ([6423e02](https://github.com/luamod/mods/commit/6423e025fdc9979469e43377b295946e26d867bf))
* **str:** return single values from gsub-backed helpers ([d8ab831](https://github.com/luamod/mods/commit/d8ab83140a2fb95ab535d0616c94ceb8c8e80b6c))
* **template:** validate template and view argument types ([e55f1a2](https://github.com/luamod/mods/commit/e55f1a2df5daa61dddef615c20d461464da96f00))

## [0.3.0](https://github.com/luamod/mods/compare/v0.2.0...v0.3.0) (2026-02-17)


### Features

* add utils module ([c440cfe](https://github.com/luamod/mods/commit/c440cfe81e99c7f3f60a255f20b35eb4262e6604))


### Bug Fixes

* **docs:** correct llms domain url prefix ([64105c1](https://github.com/luamod/mods/commit/64105c134869911a8eed3654a3f7f7d03d268651))
* **docs:** disable clean urls for llms home markdown route ([cba6745](https://github.com/luamod/mods/commit/cba6745bfe4136813277b1b5658c949bf01724c2))
* **docs:** hide llms copy buttons on home page ([adff331](https://github.com/luamod/mods/commit/adff3319df756c918c04cfa4e612433b6ff60e81))
* **docs:** hide llms copy buttons on index page ([b08c287](https://github.com/luamod/mods/commit/b08c287becc4cc2c3d42cab59120c64431c7399f))
* **validate:** harden alias lookup ([879f48f](https://github.com/luamod/mods/commit/879f48f189654ec9590d9d87339483154c03e81a))
* **validate:** normalize path validator failure messages ([fe6ccb1](https://github.com/luamod/mods/commit/fe6ccb196748997d820ce4542b1a10e6d2bf8378))
* **validate:** prevent unrelated assignments from overriding on_fail ([64eedad](https://github.com/luamod/mods/commit/64eedad2dec5657b10d1cc247f9f9697ee6b482f))


### Performance Improvements

* **stringcase:** streamline swap and sentence transforms ([ae78911](https://github.com/luamod/mods/commit/ae78911992472a2c5c217479dd250b0613dcc096))
* **str:** optimize splitlines and title paths ([6b87560](https://github.com/luamod/mods/commit/6b87560f944850218823058483cb244316834f8e))
* **str:** speed up predicates and startswith fast path ([746f883](https://github.com/luamod/mods/commit/746f883f53c3518fad9c0b04627a41fc7860a111))

## [0.2.0] - 2026-02-11

### Added

- `mods.is`, type predicates for Lua values and filesystem paths
  ([afd88a7](https://github.com/luamod/mods/commit/afd88a7)).
- `mods.operator`, operator helpers as functions
  ([d620ef9](https://github.com/luamod/mods/commit/d620ef9)).
- `mods.template`, simple template rendering with value replacement
  ([96e833c](https://github.com/luamod/mods/commit/96e833c)).
- `mods.validate`, validation predicates with customizable failure handling via
  `validate.on_fail` ([31d9b91](https://github.com/luamod/mods/commit/31d9b91)).

### Changed

- Lazy-load bundled modules on access
  ([d7d6fac](https://github.com/luamod/mods/commit/d7d6fac)).
- Lazy-load `mods.List` and `mods.Set` dependencies in `mods.List`, `mods.Set`,
  `mods.str`, and `mods.tbl`
  ([1e66b3c](https://github.com/luamod/mods/commit/1e66b3c)).

## [0.1.0] - 2026-02-08

### Added

- `mods.List`, Python-style list helpers
  ([7d2f3c8](https://github.com/luamod/mods/commit/7d2f3c8)).
- `mods.Set`, set operations and helpers
  ([ec0d08d](https://github.com/luamod/mods/commit/ec0d08d)).
- `mods.str`, string utilities modeled after Python's `str`
  ([244838a](https://github.com/luamod/mods/commit/244838a)).
- `mods.stringcase`, string case conversion helpers
  ([4a02745](https://github.com/luamod/mods/commit/4a02745)).
- `mods.tbl`, table utilities
  ([f4cbf78](https://github.com/luamod/mods/commit/f4cbf78)).

[0.2.0]: https://github.com/luamod/mods/releases/tag/v0.2.0
[0.1.0]: https://github.com/luamod/mods/releases/tag/v0.1.0
