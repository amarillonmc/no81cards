--千夜 铸刀
function c60150643.initial_effect(c)
	aux.AddFusionProcFunRep(c,c60150643.matfilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	c:EnableReviveLimit()
	
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(60150643)
	c:RegisterEffect(e12)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150643,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,60150643)
	e2:SetTarget(c60150643.thtg)
	e2:SetOperation(c60150643.thop)
	c:RegisterEffect(e2)
	
	--name change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150643,7))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,6010643)
	e3:SetCost(c60150643.cost)
	e3:SetTarget(c60150643.nametg)
	e3:SetOperation(c60150643.nameop)
	c:RegisterEffect(e3)
end

function c60150643.matfilter(c)
	return c:IsFusionSetCard(0x3b21) and c:IsType(TYPE_PENDULUM)
end
function c60150643.mfilter(c)
	return c:IsSetCard(0x3b21)
end
function c60150643.thfilter(c)
	return c:IsSetCard(0x3b21) and c:IsAbleToHand()
end
function c60150643.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150643.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150643.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60150643.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150643.costf(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c60150643.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150643.costf,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150643.costf,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60150643.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={0xcb21,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150643.nameop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(60150643,8))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c60150643.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		if code==60150610 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150610,5))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,1))
		end
		if code==60150611 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150611,4))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,2))
		end
		if code==60150612 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150612,4))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,3))
		end
		if code==60150613 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150613,6))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,4))
		end
		if code==60150614 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150614,7))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,5))
		end
		if code==60150615 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150615,4))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150643,6))
		end
	end
end

function c60150643.rstop(e,tp,eg,ep,ev,re,r,rp)
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