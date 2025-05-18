--魂锁链王·链
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_ENERGY,2}}}}
	s[c]=elements
	
end
function s.ffilter(c)
	return c:IsFusionSetCard(0x355) and c:IsFusionType(TYPE_SPELL+TYPE_TRAP)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>2 and Duel.CheckChainUniqueness()
end
function s.thfilter(c)
	return c:IsSetCard(0x355) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.efilter(e,te)
	return te:GetHandler():IsSetCard(0x355) and te:GetOwner()~=e:GetOwner()
end
function s.aclimit(e,re,tp)
	local cc=Duel.GetCurrentChain()
	local rc=re:GetHandler()
	if cc>0 then
		for i=1,cc do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if rc:IsCode(te:GetHandler():GetCode()) then return true end
		end
	end
	return false
end
