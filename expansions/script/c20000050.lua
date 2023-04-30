--幻梦无亘龙
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000051,20000057)
	local e1=fuef.SC(c,nil,"SP",nil,nil,nil,cm.con1,cm.op1,c)
	local e2=fuef.FTO(c,0,CATEGORY_ATKCHANGE,EVENT_PHASE+PHASE_BATTLE_START,nil,"M",1,cm.con1,nil,cm.tg2,cm.op2,c)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"D",{"IsCode",aux.NOT(Card.IsForbidden)},20000057)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.SelectYesNo(tp,1150) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"M","IsRace+IsFaceup",RACE_DRAGON,nil,1) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=fugf.GetFilter(tp,"M",{"IsRace+IsImmuneToEffect",aux.NOT(Card.IsFaceup)},{RACE_DRAGON,e})
	local atk=0
	for tc in aux.Next(g) do
		atk=atk+tc:GetAttack()
		local e1=fuef.S(c,nil,EFFECT_SET_BASE_ATTACK,nil,nil,0,nil,nil,nil,tc,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		atk=atk-tc:GetAttack()
	end
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local e1=fuef.S(c,nil,EFFECT_SET_BASE_ATTACK,nil,nil,atk,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
end