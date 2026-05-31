--森罗的丽人 银杏
local s,id,o=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
	--
	if not s.globle_check then
		s.globle_check=true
		s.count=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.resetcount)
		Duel.RegisterEffect(ge2,0)
	end
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.effect_check then
		s.effect_check=true
		--
		local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		Sylvan_Effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode()==EVENT_TO_GRAVE and effect:IsHasType(EFFECT_TYPE_TRIGGER_O) then
				local eff=effect:Clone()
				Sylvan_Effect[card:GetCode()]=eff
			end
			return 
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCode())
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
function s.filter(c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER)
end
function s.resetcount(e,tp,eg,ep,ev,re,r,rp)
	s.count=0
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if (re:IsHasType(EFFECT_TYPE_TRIGGER_O) or re:IsHasType(EFFECT_TYPE_TRIGGER_F)) and tc:IsSetCard(0x90) and tc:GetLocation()==LOCATION_GRAVE 
	   and not tc:IsCode(id) and tc:GetPreviousLocation()==LOCATION_DECK then
	   s.count=s.count+1
	   --s[s.count]=re
	   s[s.count]=tc:GetOriginalCode()
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	eg:KeepAlive()
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg=e:GetLabelObject()
	local eg=eg:Filter(s.cfilter,nil,tp)
	if chk==0 then return e:GetHandler():IsDiscardable() and not e:GetHandler():IsPublic() and eg:GetCount()>0 end
	e:SetLabelObject(eg)
	eg:KeepAlive()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eg=e:GetLabelObject()
	local eg=eg:Filter(s.cfilter,nil,tp)
	if c:IsRelateToEffect(e) and eg:GetCount()>0 --and not c:IsPublic() 
		then
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		--Duel.SendtoGrave(c,REASON_EFFECT+REASON_REVEAL)
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_REVEAL)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.count>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if s.count>0 then
		local i=0
		while i<s.count do
			i=i+1
			--Duel.Hint(HINT_CARD,0,s[i]:GetHandler():GetOriginalCode())
			local code=s[i]
			local te=Sylvan_Effect[code]
			local tg=te:GetTarget()
			local op=te:GetOperation()
			if te and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
				Duel.Hint(HINT_CARD,0,code)
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				c:CreateEffectRelation(e)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(e)
					tg=g:GetNext()
				end
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(e)
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(e)
					tg=g:GetNext()
				end
			end
		end
	end
end
