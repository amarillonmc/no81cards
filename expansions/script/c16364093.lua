--数码兽 铠皇兽
function c16364093.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xdc3),9,3,c16364093.ovfilter,aux.Stringid(16364093,3),3,c16364093.xyzop0)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c16364093.atkval)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16364093,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16364093)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c16364093.discon)
	e2:SetTarget(c16364093.distg)
	e2:SetOperation(c16364093.disop)
	c:RegisterEffect(e2)
	--spummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,16364093+1)
	e3:SetCondition(c16364093.spcon)
	e3:SetTarget(c16364093.sptg)
	e3:SetOperation(c16364093.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e3)
	e4:SetOperation(c16364093.chk)
	c:RegisterEffect(e4)
end
function c16364093.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(7) and c:IsSetCard(0xdc3)
end
function c16364093.xyzop0(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	mc:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c16364093.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c16364093.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and aux.NegateMonsterFilter(c)
end
function c16364093.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16364093.cfilter,1,e:GetHandler(),1-tp)
end
function c16364093.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c16364093.cfilter,nil,1-tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c16364093.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsCanBeDisabledByEffect,nil,e)
	if g:GetCount()~=0 then
		tc=g:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c16364093.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and e:GetLabel()>0
end
function c16364093.spfilter(c,e,tp)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,c)
end
function c16364093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16364093.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16364093.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.SelectMatchingCard(tp,c16364093.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and tc:IsType(TYPE_XYZ) and tc:IsFaceup() and ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,ct,nil)
		if #og>0 then
			Duel.BreakEffect()
			Duel.Overlay(tc,og)
		end
	end
end
function c16364093.chk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetOverlayCount())
end