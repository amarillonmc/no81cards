--fate·宇宙XX
function c9950454.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9950454.matfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_MZONE+LOCATION_HAND,0,aux.tdcfop(c))
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
  --copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950454,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetCost(c9950454.cpcost)
	e2:SetTarget(c9950454.cptg)
	e2:SetOperation(c9950454.cpop)
	c:RegisterEffect(e2)
 --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950454,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9950454)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9950454.thtg)
	e3:SetOperation(c9950454.thop)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950454.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950454.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950454,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950453,3))
end
function c9950454.matfilter(c)
	return c:IsLevelAbove(5) and c:IsFusionSetCard(0xba5) and bit.band(c:GetType(),0x81)==0x81
end
function c9950454.thfilter(c)
	return c:IsSetCard(0xba5) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c9950454.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950454.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950454.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950454.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950454,0))
end
function c9950454.cpfilter(c)
	return c:IsSetCard(0xba5) and c:GetType()==0x82  and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c9950454.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c9950454.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9950454.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950454.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c9950454.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950454,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9950454,4))
end
