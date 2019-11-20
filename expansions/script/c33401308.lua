--五河士道 鏖杀公
function c33401308.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	 aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc342),c33401308.fa,true)
  --copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetDescription(aux.Stringid(33401308,0))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,33401308)
	e6:SetTarget(c33401308.cptg)
	e6:SetOperation(c33401308.cpop)
	c:RegisterEffect(e6)
  --to hand from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33401308,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c33401308.adtg)
	e4:SetOperation(c33401308.adop)
	c:RegisterEffect(e4)
end
function c33401308.fa(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_WARRIOR)
end
function c33401308.cpfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x341) and c:IsRace(RACE_WARRIOR)
end
function c33401308.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c33401308.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33401308.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c33401308.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
end
function c33401308.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	   c:RegisterFlagEffect(33401301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c33401308.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c33401308.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() 
end
function c33401308.thfilter3(c)
	return c:IsSetCard(0x5341)  and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL))
end
function c33401308.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33401308.thfilter3,tp,LOCATION_GRAVE,0,1,nil)	
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33401308.adop(e,tp,eg,ep,ev,re,r,rp)   
	local g1=Duel.GetMatchingGroup(c33401308.thfilter3,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:SelectSubGroup(tp,c33401308.check,false,1,2) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end
function c33401308.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(c33401308.thfilter1,1,nil,c) then res=res+1 end
	if g:IsExists(c33401308.thfilter2,1,nil,c) then res=res+4 end
	return res==5 
	end
end