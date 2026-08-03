-- 黑暗之女 莉莉丝
Lilith=Lilith or {}
Lilith.loaded_metatable_list={}

local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return aux.IsCodeListed(c,id) and c:IsAbleToHand()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.negnextop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.negnextop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	local rc=re:GetHandler()
	if not (rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP)) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:Reset()
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local rc=re:GetHandler()
	if not rc:IsType(TYPE_MONSTER) and not rc:IsType(TYPE_SPELL) and not rc:IsType(TYPE_TRAP) then return end
	local total=Duel.GetFlagEffect(tp,id)
	local used=Duel.GetFlagEffect(tp,id+10000000)
	if used>=total then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
 		Duel.RegisterFlagEffect(tp,id+10000000,0,0,1)
	end
end

function Lilith.allback(e,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	for codeid=71290310,71290317 do
		local num=Duel.GetFlagEffect(tp,codeid)
		if num~=0 and Lilith.actcheck~=1 then
			local tokenc=Duel.CreateToken(tp,codeid)
			if tokenc:CheckActivateEffect(true,true,false)==nil then return end
			local te=tokenc:GetActivateEffect()
			for i=1,num do
				--Debug.Message(Duel.GetFlagEffect(tp,codeid))
				--Debug.Message(codeid)
				if Duel.SelectYesNo(tp,aux.Stringid(codeid,1)) then
					Lilith.actcheck=1
					Lilith.ActivateEffect(te,tp,e,eg,ep,ev,re,r,rp)
					Lilith.actcheck=0
				end
			end
		end
	end
end


--MTC.ActivateEffect(需要适用的e,调用该函数的tp,调用该函数的e)
function Lilith.ActivateEffect(e,tp,oe,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end






