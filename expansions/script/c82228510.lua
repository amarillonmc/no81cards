function c82228510.initial_effect(c)  
	--summon with no tribute  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228510,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetCondition(c82228510.ntcon)  
	e1:SetOperation(c82228510.ntop)  
	c:RegisterEffect(e1)
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228510,1))  
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,82228510)  
	e2:SetCost(c82228510.descost)  
	e2:SetTarget(c82228510.destg)  
	e2:SetOperation(c82228510.desop)  
	c:RegisterEffect(e2)   
end  
function c82228510.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228510.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228510,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetTarget(c82228510.tgtg)  
	e1:SetOperation(c82228510.tgop)  
	e1:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e1)  
end  
function c82228510.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228510.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228510.cfilter(c)  
	return c:IsSetCard(0x291) and c:IsDiscardable()  
end  
function c82228510.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228510.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,c82228510.cfilter,1,1,REASON_COST+REASON_DISCARD)  
end  
function c82228510.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c82228510.desfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0) 
end
function c82228510.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  