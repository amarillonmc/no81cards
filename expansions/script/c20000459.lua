--威天之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RInitial()
cm.e1 = fuef.FTO("DR"):Pro("DE+TG"):Ran("M"):Ctl(1):Func("SelfDraw_con,tg1,op1")
function cm.tg1f(g)
	return function(e,ep,tp)
		return not g:IsContains(e:GetHandler())
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp, "+MS", "TgChk", e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g = fugf.SelectTg(tp, g, 1, ev)
	Duel.SetChainLimit(cm.tg1f(g))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc = fusf.GetTarget(e)
	if not tc then return end
	local e1 = fuef.S(e,EFFECT_DISABLE,tc):Des(3):Pro("HINT"):Con("op1con1"):Res("STD")
	e1(EFFECT_CANNOT_TRIGGER):Con("op1con2")
end
local e1g1 = fugf.MakeFilter("M", "IsTyp+IsRac+IsPos", "RI+M,DR,FU")
function cm.op1con1(e)
	if #e1g1(e:GetOwnerPlayer()) == 0 then return false end
	local c = e:GetHandler()
	if c:IsType(TYPE_TRAPMONSTER) then
		return c:IsFaceup()
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsFaceup() and not c:IsDisabled()
	else
		return Auxiliary.NegateMonsterFilter(c)
	end
end
function cm.op1con2(e)
	return #e1g1(e:GetOwnerPlayer()) > 0
end