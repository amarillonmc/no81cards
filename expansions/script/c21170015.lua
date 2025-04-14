--天启录的末日钟
function c21170015.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170015.xyzcon())
	e0:SetTarget(c21170015.xyztg())
	e0:SetOperation(aux.XyzLevelFreeOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170015,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21170015)
	e1:SetCondition(c21170015.con)
	e1:SetTarget(c21170015.tg)
	e1:SetOperation(c21170015.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170015,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21170016)
	e2:SetTarget(c21170015.tg2)
	e2:SetOperation(c21170015.op2)
	c:RegisterEffect(e2)
end
function c21170015.xyz(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_FAIRY) and c:IsXyzLevel(xyzc,10) or c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170015.goal(g,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c21170015.xyzcon()
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
					mg=og:Filter(c21170015.xyz,nil,c)
				else
					mg=Duel.GetMatchingGroup(c21170015.xyz,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(c21170015.goal,minc,maxc,tp,c)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function c21170015.xyztg()
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
					mg=og:Filter(c21170015.xyz,nil,c)
				else
					mg=Duel.GetMatchingGroup(c21170015.xyz,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,c21170015.goal,cancel,minc,maxc,tp,c)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function c21170015.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c21170015.q(c)
	return c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL and c:IsCanOverlay()
end
function c21170015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(c21170015.q,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c21170015.q,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,(#og+1)*300)
end
function c21170015.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
	local og=tc:GetOverlayGroup()
		if #og>0 then
		Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.AdjustAll()
		og=c:GetOverlayGroup()
		if #og>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(#og*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		end		
	end
end
function c21170015.w(c)
	return c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL and c:IsCanOverlay()
end
function c21170015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c21170015.w,tp,LOCATION_GRAVE,0,1,nil) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c21170015.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local dg=Duel.GetMatchingGroup(c21170015.w,tp,LOCATION_GRAVE,0,nil)
	if #og<=0 or #dg<=0 then return end
	local s=math.min(#og,#dg)
	if s>2 then s=2 end
	Duel.Hint(3,tp,HINTMSG_REMOVEXYZ)
	local g=og:Select(tp,1,s,nil)
	local s2=Duel.SendtoGrave(g,REASON_EFFECT)
	if s2>0 then
	dg=Duel.GetMatchingGroup(c21170015.w,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(3,tp,HINTMSG_XMATERIAL)
	g=dg:Select(tp,s2,s2,nil)
	Duel.Overlay(c,g)
	end
end