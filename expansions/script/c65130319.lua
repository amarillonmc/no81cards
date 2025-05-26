--串联连携
function c65130319.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130319,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c65130319.stcon)
	e2:SetTarget(c65130319.sttg)
	e2:SetOperation(c65130319.stop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65130319,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,65130319)
	e3:SetCondition(c65130319.thcon)
	e3:SetTarget(c65130319.thtg)
	e3:SetOperation(c65130319.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c65130319.stcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c65130319.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)~=0 end
end
function c65130319.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c65130319.cfilter(c,sp)
	return c:IsControler(sp)
end
function c65130319.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65130319.cfilter,1,nil,1-tp)
end
function c65130319.spfilter(c,tcode,e,tp)
	return not c:IsCode(tcode) and c:IsDefense(1157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65130319.thfilter(c)
	return c:IsAttack(878) and c:IsFaceup() and c:IsAbleToHand()
end
function c65130319.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	if chk==0 then return Duel.IsExistingMatchingCard(c65130319.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c65130319.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c65130319.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local tcode=tc:GetCode()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65130319.spfilter,tp,LOCATION_DECK,0,1,nil,tcode,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(65130319,1)) then
		Duel.BreakEffect()
		tcode=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c65130319.spfilter,tp,LOCATION_DECK,0,1,1,nil,tcode,e,tp)
		local sc=sg:GetFirst()
		local cid=0
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1,true)	  
			if not tc:IsType(TYPE_TRAPMONSTER) then		   
				 cid=sc:CopyEffect(tcode,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			end
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(65130319,2))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCountLimit(1)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetLabelObject(e1)
			e3:SetLabel(cid)
			e3:SetOperation(c65130319.rstop)
			sc:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
		end
	end
end
function c65130319.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
