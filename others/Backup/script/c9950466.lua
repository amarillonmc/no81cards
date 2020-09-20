--角子老虎机AM-1995-2-16
function c9950466.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950466,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9950466.reccon)
	e3:SetTarget(c9950466.rectg)
	e3:SetOperation(c9950466.recop)
	c:RegisterEffect(e3)
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950466,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9950466.target)
	e1:SetOperation(c9950466.operation2)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950466.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950466.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950466,0))
end
function c9950466.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950466.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1700)
end
function c9950466.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c9950466.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
end
function c9950466.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950466.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2=Duel.TossDice(tp,2)
	if d2>d1 then d1,d2=d2,d1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(d1*700)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	if d1+d2==7 then
		local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>1
		local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950466.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and spg:GetCount()>0
		local b3=Duel.IsPlayerCanDraw(tp,3)
		if not b1 and not b2 and not b3 then return end
		local op=0
		if b1 and not b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,1))
		elseif not b1 and b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,2))+1
		elseif not b1 and not b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,3))+2
		elseif b1 and b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,1),aux.Stringid(9950466,2))
		elseif b1 and not b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,1),aux.Stringid(9950466,3)) if op==1 then op=2 end
		elseif not b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(9950466,2),aux.Stringid(9950466,3))+1
		else op=Duel.SelectOption(tp,aux.Stringid(9950466,1),aux.Stringid(9950466,2),aux.Stringid(9950466,3)) end
		if op==0 then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Draw(tp,3,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
