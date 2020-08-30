function c82228503.initial_effect(c)  
	--summon with no tribute  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228503,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetCondition(c82228503.ntcon)  
	e1:SetOperation(c82228503.ntop)  
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228503,2))  
	e2:SetCategory(CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetCountLimit(1,82228503)  
	e2:SetTarget(c82228503.tg2tg)  
	e2:SetOperation(c82228503.tg2op)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e3)	
end  
function c82228503.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228503.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228503,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetTarget(c82228503.tgtg)  
	e1:SetOperation(c82228503.tgop)  
	e1:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e1)  
end  
function c82228503.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228503.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228503.tg2filter(c)  
	return c:IsSetCard(0x291) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) 
end  
function c82228503.tg2tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228503.tg2filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function c82228503.tg2op(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c82228503.tg2filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end