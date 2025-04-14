--天启录的忏悔者
function c21170010.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170010.xyzcon())
	e0:SetTarget(c21170010.xyztg())
	e0:SetOperation(aux.XyzLevelFreeOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170010,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,21170010)
	e1:SetCost(c21170010.cost)
	e1:SetTarget(c21170010.tg)
	e1:SetOperation(c21170010.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170010,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,21170011)
	e2:SetTarget(c21170010.tg2)
	e2:SetOperation(c21170010.op2)
	c:RegisterEffect(e2)	
end
function c21170010.xyz(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_FAIRY) and c:IsXyzLevel(xyzc,10) or c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170010.goal(g,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c21170010.xyzcon()
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(c21170010.xyz,nil,c)
				else
					mg=Duel.GetMatchingGroup(c21170010.xyz,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(c21170010.goal,minc,maxc,tp,c)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function c21170010.xyztg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(c21170010.xyz,nil,c)
				else
					mg=Duel.GetMatchingGroup(c21170010.xyz,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,c21170010.goal,cancel,minc,maxc,tp,c)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c21170010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21170010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
end
function c21170010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c21170010.q(c,e) 
	return c:IsSetCard(0x6917) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c21170010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c21170010.q,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return tg:GetClassCount(Card.GetCode)>=1 end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=tg:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_GRAVE)
end
function c21170010.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end