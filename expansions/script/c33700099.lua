--动物的朋友 LUCKY BEAST
function c33700099.initial_effect(c)
   --lv
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33700099,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCountLimit(1)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c33700099.con)
	e0:SetTarget(c33700099.tg)
	e0:SetOperation(c33700099.op)
	c:RegisterEffect(e0) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c33700099.con)
	e1:SetTarget(c33700099.target)
	e1:SetOperation(c33700099.operation)
	c:RegisterEffect(e1)
end
function c33700099.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c33700099.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local t={}
	local i=1
	for i=1,11 do t[i]=i end 
	Duel.Hint(HINT_SELECTMSG,tp,567)
	 local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(lv)
end
function c33700099.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c33700099.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsAbleToRemove() and c:IsSetCard(0x442)
		and Duel.IsExistingMatchingCard(c33700099.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c33700099.filter2(c,e,tp,lv)
	return c:GetLevel()==lv  and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c33700099.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33700099.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33700099.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel()) 
	local tc=g:GetFirst()
	local lv=e:GetHandler():GetLevel()+tc:GetLevel()
	local g=Group.FromCards(e:GetHandler(),tc)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c33700099.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
