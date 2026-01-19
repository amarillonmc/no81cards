--霞之谷的喷霞
local s,id,o=GetID()
function s.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	if s.counter==nil then
		s.counter=true
		BL_MW_thtable={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_TO_HAND)
		ge2:SetOperation(s.addcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.resetcount(e,tp,eg,ep,ev,re,r,rp)
	BL_MW_thtable={}
end
function s.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsPreviousLocation(LOCATION_DECK) and (tc:GetPreviousPosition(POS_FACEUP) or tc:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)) then
			local oc=tc:GetOriginalCode()
			if not s.in_array(oc,BL_MW_thtable) then
				BL_MW_thtable[#BL_MW_thtable+1]=oc
			end
		end
		tc=eg:GetNext()
	end
end
function s.actfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.cfilter1(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x37) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_REPTILE))) and c:IsAbleToHand() and not c:IsCode(id)
		and Duel.IsExistingTarget(s.cfilter2,tp,0,LOCATION_ONFIELD,2,c)
end
function s.cfilter2(c)
	return c:IsAbleToHand() and not (c:IsCode(id) and c:IsFaceup())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,s.cfilter2,tp,0,LOCATION_ONFIELD,2,2,g)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,3,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsAbleToHand,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.distg(e,c)
	local code=c:GetOriginalCode()
	return not c:IsSetCard(0x37) and s.in_array(code,BL_MW_thtable) and (c:IsType(TYPE_EFFECT|TYPE_SPELL|TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local code=tc:GetOriginalCodeRule()
	return not tc:IsSetCard(0x37) and s.in_array(code,BL_MW_thtable)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
