function c82228512.initial_effect(c)  
	--summon with no tribute  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228512,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetCondition(c82228512.ntcon)  
	e1:SetOperation(c82228512.ntop)  
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228512,2))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82228512)  
	e2:SetRange(LOCATION_HAND)   
	e2:SetTarget(c82228512.sptg)  
	e2:SetOperation(c82228512.spop)  
	c:RegisterEffect(e2)   
end  
function c82228512.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228512.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228512,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetTarget(c82228512.tgtg)  
	e1:SetOperation(c82228512.tgop)  
	e1:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e1)  
end  
function c82228512.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228512.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228512.filter(c)  
	return c:IsFaceup() and c:IsRank(8) and c:GetOverlayCount()>0 
end  
function c82228512.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82228512.filter(chkc) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
		and Duel.IsExistingTarget(c82228512.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82228512.filter,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end 
function c82228512.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if not tc:IsRelateToEffect(e) then return end   
	if tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end  
end  