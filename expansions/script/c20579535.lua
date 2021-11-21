--森罗的丽人 银杏
function c20579535.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20579535,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(3,20579535)
	e1:SetCondition(c20579535.thcon)
	e1:SetTarget(c20579535.thtg)
	e1:SetOperation(c20579535.thop)
	c:RegisterEffect(e1)
	if not c20579535.globle_check then
		c20579535.globle_check=true
		c20579535.count=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c20579535.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c20579535.resetcount)
		Duel.RegisterEffect(ge2,0)
	end
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20579535,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c20579535.spcon)
	e2:SetTarget(c20579535.sptg)
	e2:SetOperation(c20579535.spop)
	c:RegisterEffect(e2)
end
function c20579535.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c20579535.count=0
end
function c20579535.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0x90) and tc:GetLocation()==LOCATION_GRAVE 
	   and not tc:IsCode(20579535) and tc:GetPreviousLocation()==LOCATION_DECK then
	   c20579535.count=c20579535.count+1
	   c20579535[c20579535.count]=re
	end
end
function c20579535.cfilter(c,tp)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE)
end
function c20579535.thcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	eg:KeepAlive()
	return eg:IsExists(c20579535.cfilter,1,nil,tp)
end
function c20579535.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg=e:GetLabelObject()
	local eg=eg:Filter(c20579535.cfilter,nil,tp)
	if chk==0 then return e:GetHandler():IsDiscardable() and not e:GetHandler():IsPublic() and eg:GetCount()>0 end
	e:SetLabelObject(eg)
	eg:KeepAlive()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c20579535.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eg=e:GetLabelObject()
	local eg=eg:Filter(c20579535.cfilter,nil,tp)
	if c:IsRelateToEffect(e) and eg:GetCount()>0 and not c:IsPublic() then
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_REVEAL)
	end
end
function c20579535.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_REVEAL)
end
function c20579535.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20579535.count>0 end
end
function c20579535.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c20579535.count>0 then
		e:SetLabel(0)
		while e:GetLabel()<c20579535.count do
			e:SetLabel(e:GetLabel()+1)
			Duel.Hint(HINT_CARD,0,c20579535[e:GetLabel()]:GetHandler():GetOriginalCode())
			local te=c20579535[e:GetLabel()]:Clone()
			local tg=te:GetTarget()
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
