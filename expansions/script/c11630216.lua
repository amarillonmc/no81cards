--暗型镜·破坏与创造
local m=11630216
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
cm.SetCard_xxj_Mirror=true
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			local tc=g:GetFirst()
			local atk=tc:GetAttack()
			local att=tc:GetAttribute()
			local ra=tc:GetRace()
			local def=tc:GetDefense()
			local lv=tc:GetLevel()
			local code=tc:GetCode()
			local ph=Duel.GetTurnCount()
			--e:SetLabel(code,ra,att,lv,atk,def,ph)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e2:SetCountLimit(1)
			e2:SetLabel(code,ra,att,lv,atk,def,ph)
			--e2:SetLabelObject((code,ra,att,lv,atk,def,ph))
			e2:SetCondition(cm.spcon)
			e2:SetOperation(cm.spop)
			e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local code,ra,att,lv,atk,def,ph=e:GetLabel()	
	return  (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) and Duel.GetTurnPlayer()==tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if (ft1<=0 and ft2<=0) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local code,ra,att,lv,atk,def,ph=e:GetLabel()	  
	local g=Group.CreateGroup()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,TYPES_TOKEN_MONSTER,atk,def,lv,ra,att) then
		ft1=0
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(1-tp,code,0,TYPES_TOKEN_MONSTER,atk,def,lv,ra,att) then
		ft2=0
	end 
	for i=1,ft1 do	
		local token=Duel.CreateToken(tp,11630217)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(ra)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(att)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK)
		e4:SetValue(atk)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_DEFENSE)
		e5:SetValue(def)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(code)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6)
		--
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	for i=1,ft2 do	
		local token=Duel.CreateToken(1-tp,11630217)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(ra)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(att)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK)
		e4:SetValue(atk)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_DEFENSE)
		e5:SetValue(def)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(code)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6)
		--
		Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.BreakEffect()
	Duel.SpecialSummonComplete()
end