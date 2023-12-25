--幻梦无亘龙
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000051,20000057)
	fuef.SC(c,c,"SP,,,,,con1,op1")
	fuef.FTO(c,c,EVENT_PHASE+PHASE_BATTLE_START,"0,ATK,,M,1,,,tg2,op2")
end
--e1
cm.con1=function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"D","IsTyp+IsCod+CheckEquipTarget+CheckUniqueOnField-IsForbidden",{"EQ,57",c,{tp,LOCATION_SZONE}})
	if #g==0 or not fucf.Filter(c,"IsPos+IsLoc","FU,M") or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.SelectYesNo(tp,1068) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.Equip(tp,tc,c,true,true)
	Duel.EquipComplete()
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"M","IsRac+IsPos","DR,FU",1) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c,g,atk,e1=e:GetHandler(),fugf.GetFilter(tp,"M","IsRac+IsPos-IsImmuneToEffect",{"DR,FU",e}),0
	for tc in aux.Next(g) do
		atk=atk+tc:GetAttack()
		e1=fuef.S(c,tc,EFFECT_SET_ATTACK_FINAL,",,,0,,,,EV+STD+PH/BPE")
		atk=atk-tc:GetAttack()
	end
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	e1(nil,c,"VAL:"..(atk))
end