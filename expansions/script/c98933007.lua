--天外来客 群星梦魇
function c98933007.initial_effect(c)
	c:SetUniqueOnField(1,0,98933007)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98933007,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98933007.con)
	e0:SetTarget(c98933007.tg)
	e0:SetOperation(c98933007.op)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98933007.efilter)
	c:RegisterEffect(e1)
	--X Material
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98933007.discon)
	e3:SetOperation(c98933007.disop)
	c:RegisterEffect(e3)
	if not c98933007.global_check then
		c98933007.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c98933007.reccon)
		ge1:SetOperation(c98933007.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	if not c98933007.global_check2 then
		c98933007.global_check2=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetCondition(c98933007.reccon2)
		ge2:SetOperation(c98933007.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c98933007.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98933007.con(e,c)
	local tp=e:GetHandler():GetOwner()
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c98933007.xyzfilter1,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) and Duel.GetFlagEffect(tp,98933007)>=13
end
function c98933007.xyzfilter1(c,e)
	return c:IsCanBeXyzMaterial(e:GetHandler())
end
function c98933007.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c98933007.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end  
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)  
	mg:DeleteGroup()
end
function c98933007.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),98933007,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c98933007.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	return eg:IsExists(c98933007.ecfilter,1,nil,tp)
end
function c98933007.ecfilter(c,tp)
	return c:IsSummonPlayer(tp) and not c:IsSummonableCard()
end
function c98933007.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),98933017,0,0,1)
		tc=eg:GetNext()
	end
	if Duel.GetFlagEffect(tp,98933017)>=5 then Duel.Win(tp,0x0) end
end
function c98933007.reccon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	return eg:IsExists(c98933007.ecfilter2,1,nil,tp)
end
function c98933007.ecfilter2(c,tp)
	return c:IsSummonPlayer(tp) and c:IsCode(98933007)
end
function c98933007.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c98933007.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98933007,2)) and c:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_CARD,0,98933007)
		if rc:IsRelateToEffect(re) and rc:IsCanOverlay() then
			if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
			   rc:CancelToGrave()
			   Duel.Overlay(c,Group.FromCards(rc))	
			else 
			   Duel.Overlay(c,Group.FromCards(rc))	
			end
			if c:GetOverlayCount()>=5 then Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
		end
	end
end