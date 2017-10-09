### Sage script to automate calculation of Gaussian error propagation.
### 2014-05-24 Simon May
import re

#def gauss_error(func):
#	"""Do a Gaussian error propagation calculation on the function specified
#	by func.
#	
#	func -- String containing the name of a callable symbolic expression.
#	
#	The result is added to the global namespace as "Delta_{func}".
#	"""
#	# allow only valid Python identifiers
#	if not re.match(r'^[^\d\W]\w*\Z', func):
#		raise ValueError('Did not pass a valid identifier')
#	func_str = func
#	global gauss_error
#	glob = gauss_error.func_globals
#	func = glob[func_str]
#	args = func.args()
#	args_delta = lambda arg: SR.var('Delta_' + str(arg), latex_name='\Delta ' + str(arg))
#	for arg in args:
#		res += (func.diff(arg) * args_delta(arg))^2
#	res = sqrt(res).function(*(args + tuple(args_delta(arg) for arg in args)))
#	glob['delta_' + func_str] = res
#	return res

def gauss_error(func):
	"""Do a Gaussian error propagation calculation on the function specified
	by func.
	"""
	args = func.args()
	args_delta = lambda arg: SR.var('Delta_' + str(arg), latex_name='\Delta ' + latex(arg))
	res = 0
	for arg in args:
		res += (func.diff(arg) * args_delta(arg))^2
	res = sqrt(res).function(*(args + tuple(args_delta(arg) for arg in args)))
	return res

def func_to_expr(func):
	args = func.args()
	return func(*args)

def average(numbers):
	avg = 0
	for num in numbers:
		avg += num
	return avg / len(numbers)

def standard_deviation(numbers):
	avg = average(numbers)
	stddev = 0
	for num in numbers:
		stddev += (num - avg)^2
	return sqrt(stddev / (len(numbers) - 1))

def statistical_error(numbers, tau):
	stddev = standard_deviation(numbers)
	return stddev * tau / sqrt(len(numbers))

import sys

def SI(value, error=0, unit=None, digits=3, exp=None):
	error = abs(error)
	command = "\\SI"
	unitstr = "{" + str(unit) + "}"
	expstr = ""
#XXX	if value in RR: ...
	if unit is None:
		command = "\\num"
		unitstr = ""
	val_magnitude = order_of_magnitude(value)
	if error == 0:
		if exp is None:
			exp = 0
		else:
			expstr = " e" + str(exp)
		return ("%s{%." + str(digits) + "f %s}%s") % (command, value/10^exp, expstr, unitstr)
	else:
		err_magnitude = order_of_magnitude(error)
		if exp is None:
			exp = round((val_magnitude + err_magnitude)/2)
			if abs(val_magnitude) < 6 and abs(err_magnitude) < 6:
				exp = 0
			else:
				expstr = " e" + str(exp)
		return ("%s{%." + str(digits) + "f +- %." + str(digits) + "f%s}%s") % (command, value/10^exp, error/10^exp, expstr, unitstr)

def order_of_magnitude(value):
	return floor(log(abs(value), 10))

__SI = {
	'm': units.length.meter,
	's': units.time.second,
	'Hz': units.frequency.hertz,
	'g': units.mass.gram,
	'N': units.force.newton,
	'Pa': units.pressure.pascal,
	'J': units.energy.joule,
	'eV': units.energy.electron_volt,
	'W': units.power.watt,
	'A': units.current.ampere,
	'C': units.charge.coulomb,
	'V': units.electric_potential.volt,
	'T': units.magnetic_field.tesla,
	'ohm': units.resistance.ohm,
	'H': units.inductance.henry,
	'F': units.capacitance.farad,
	'K': units.temperature.kelvin,
	'mol': units.amount_of_substance.mole,
	'cd': units.luminous_intensity.candela
}

__SI_prefixes = {
	'y': units.si_prefixes.yocto,
	'z': units.si_prefixes.zepto,
	'a': units.si_prefixes.atto,
	'f': units.si_prefixes.femto,
	'p': units.si_prefixes.pico,
	'n': units.si_prefixes.nano,
	'u': units.si_prefixes.micro,
	'm': units.si_prefixes.milli,
	'c': units.si_prefixes.centi,
	'd': units.si_prefixes.deci,
	'da': units.si_prefixes.deca,
	'h': units.si_prefixes.hecto,
	'k': units.si_prefixes.kilo,
	'M': units.si_prefixes.mega,
	'G': units.si_prefixes.giga,
	'T': units.si_prefixes.tera,
	'P': units.si_prefixes.peta,
	'E': units.si_prefixes.exa,
	'Z': units.si_prefixes.zetta,
	'Y': units.si_prefixes.yotta
}

#def SI(amount, unit):
#	return amount * __SI[unit]

