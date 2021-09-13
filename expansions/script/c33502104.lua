--自然色彩 霞绯落枫
Duel.LoadScript("c33502100.lua")
local m=33502104
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e9=Suyuz.tograve(c,CATEGORY_SUMMON,m,cm.op)
	--HZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(Suyuz.gaincon(m))
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.hop)
	c:RegisterEffect(e3)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502104"]=cm.disop
end
--e1
function cm.op(e,tp)
	local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.disop)
	e1:SetLabel(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabel()
	if te==re or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	local tep=re:GetHandlerPlayer()
	if not (Duel.IsExistingMatchingCard(cm.splimit0,tp,LOCATION_HAND,0,1,nil))  then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		  local g=Duel.SelectMatchingCard(tp,cm.splimit0,tp,LOCATION_HAND,0,1,1,nil)
		  local tc=g:GetFirst()
		  if tc then
			  local s1=tc:IsSummonable(true,nil,1)
			  local s2=tc:IsMSetable(true,nil,1)
			  if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK,POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				  Duel.Summon(tp,tc,true,nil,1)
			  else
				  Duel.MSet(tp,tc,true,nil,1)
			  end
		  end
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function cm.splimit0(c)
	return c:IsRace(RACE_PLANT) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and c:IsLevel(9)
end
function cm.splimit2(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,1500,1250,9,RACE_PLANT,ATTRIBUTE_LIGHT)
end
--e3
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(cm.splimit2,tp,0,LOCATION_ONFIELD,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.splimit2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	e1:SetReset(RESET_EVENT+0x47c0000)
	tc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_PLANT)
	tc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	tc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(1500)
	tc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(1250)
	tc:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(9)
	tc:RegisterEffect(e6,true)
	if Duel.SpecialSummon(tc,0,tp,1-tp,true,false,POS_FACEUP)~=0 then
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_ADD_SETCODE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetValue(0x2a80)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e8:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e8:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e8,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
	end
end
