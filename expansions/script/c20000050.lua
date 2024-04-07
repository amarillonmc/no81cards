--无亘帝皇龙
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000051,20000057)
	fuef.SC(c,"SP"):Func("con1,op1")
	fuef.FTO(c,EVENT_PHASE+PHASE_BATTLE_START):CAT("ATK"):RAN("M"):CTL(1):Func("tg2,op2")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"D","IsTyp+IsCod+CheckEquipTarget+CheckUniqueOnField-IsForbidden",{"EQ,57",c,{tp,LOCATION_SZONE}})
	if #g==0 or not fucf.Filter(c,"IsPos+IsLoc","FU,M") or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.SelectYesNo(tp,1068) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc = g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.Equip(tp,tc,c,true,true)
	Duel.EquipComplete()
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp, "M", "IsRac+IsPos+Not",{"DR,FU", e}, 1) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c, g = e:GetHandler(), fugf.GetFilter(tp, "M+M", "IsRac+IsPos+Not-IsImm", {"DR,FU", e, e})
	local atk, e1 = c:GetBaseAttack()
	for tc in aux.Next(g) do
		atk = atk + tc:GetAttack()
		e1 = fuef.S(c,EFFECT_SET_ATTACK_FINAL,tc):VAL(0):RES("EV+STD+PH/BPE")
		atk = atk - tc:GetAttack()
	end
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	e1(EFFECT_SET_BASE_ATTACK, c):VAL(atk)
end