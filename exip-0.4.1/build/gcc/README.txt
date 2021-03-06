/**
 * @defgroup build_gcc Build using GCC
 *
 * @brief Information on how to build exip using GCC toolchain.
 *
 * Compiler options such as debugging support and optimization parameters
 * are located in a subfolder for each build target under build/gcc/[target]
 * 
 * [module_name].mk - help makefiles used by the main Makefile located in build/gcc.
 * <br/>
 * Make targets:
 *   <ul>
 *     <li>all - compiles the EXIP library to object files in the /bin folder</li>
 *     <li>check - runs all unit tests</li>
 *     <li>examples - build samples' executables in /bin/examples</li>
 *     <li>clean - deletes the bin/ directory</li>
 *     <li>utils - builds exip utility applications</li>
 *     <li>doc - generates Doxygen documentation</li>
 *     <li>lib - generates a static library libexip.a in bin/lib</li>
 *     <li>dynlib - generates a dynamic library libexip.so in bin/lib</li>
 *   </ul>
 * 
 * Additionally a command-line argument <em>target</em> can be used to specify the target platform
 * (pc by default). For example:
 * <code>
 * 		make target=oe-armv5te lib
 * </code> 
 *
 * @date Jan 29, 2011
 * @author Rumen Kyusakov
 * @version 0.4
 * @par[Revision] $Id: README.txt 205 2012-09-04 11:19:04Z kjussakov $
 */