--神影依·卡通神子晶
function c40008517.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40008517.regcon)
	e1:SetOperation(c40008517.atklimit)
	c:RegisterEffect(e1)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008517.dircon)
	c:RegisterEffect(e4)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c40008517.splimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008517,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40008517)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c40008517.discon)
	e3:SetTarget(c40008517.distg)
	e3:SetOperation(c40008517.disop)
	c:RegisterEffect(e3)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008517,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c40008517.thtg)
	e5:SetOperation(c40008517.thop)
	c:RegisterEffect(e5)	
	--fusion material   
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_FUSION_MATERIAL)
	e8:SetCondition(c40008517.FShaddollCondition(attr))
	e8:SetOperation(c40008517.FShaddollOperation(attr))
	c:RegisterEffect(e8)
end
function c40008517.FShaddollFilter(c,fc,attr)
	return (c40008517.FShaddollFilter1(c) or c40008517.FShaddollFilter2(c,attr)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c40008517.FShaddollExFilter(c,fc,attr)
	return c:IsFaceup() and c40008517.FShaddollFilter(c,fc,attr)
end
function c40008517.FShaddollFilter1(c)
	return c:IsFusionSetCard(0x62)
end
function c40008517.FShaddollFilter2(c,attr)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) or c:IsCode(40008534)
end
function c40008517.FShaddollSpFilter1(c,tp,mg,exg,attr,chkf)
	return mg:IsExists(c40008517.FShaddollSpFilter2,1,c,tp,c,attr,chkf) or (exg and exg:IsExists(c40008517.FShaddollSpFilter2,1,c,tp,c,attr,chkf))
end
function c40008517.FShaddollSpFilter2(c,tp,mc,attr,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(c40008517.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not c40008517.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	return ((c40008517.FShaddollFilter1(c) and c40008517.FShaddollFilter2(mc,attr))
		or (c40008517.FShaddollFilter2(c,attr) and c40008517.FShaddollFilter1(mc)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg)>0)
end
function c40008517.FShaddollCondition(attr)
	return  function(e,g,gc,chkf)
				if g==nil then return c40008517.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local mg=g:Filter(c40008517.FShaddollFilter,nil,c,attr)
				local tp=e:GetHandlerPlayer()
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					exg=Duel.GetMatchingGroup(c40008517.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr)
				end
				if gc then
					if not mg:IsContains(gc) then return false end
					return c40008517.FShaddollSpFilter1(gc,tp,mg,exg,attr,chkf)
				end
				return mg:IsExists(c40008517.FShaddollSpFilter1,1,nil,tp,mg,exg,attr,chkf)
			end
end
function c40008517.FShaddollOperation(attr)
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
				local c=e:GetHandler()
				local mg=eg:Filter(c40008517.FShaddollFilter,nil,c,attr)
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					exg=Duel.GetMatchingGroup(c40008517.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr)
				end
				local g=nil
				if gc then
					g=Group.FromCards(gc)
					mg:RemoveCard(gc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g=mg:FilterSelect(tp,c40008517.FShaddollSpFilter1,1,1,nil,tp,mg,exg,attr,chkf)
					mg:Sub(g)
				end
				if exg and exg:IsExists(c40008517.FShaddollSpFilter2,1,nil,tp,g:GetFirst(),attr,chkf)
					and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
					fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=exg:FilterSelect(tp,c40008517.FShaddollSpFilter2,1,1,nil,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=mg:FilterSelect(tp,c40008517.FShaddollSpFilter2,1,1,nil,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				end
				Duel.SetFusionMaterial(g)
			end
end
function c40008517.TuneMagicianFilter(c,e)
	local f=e:GetValue()
	return f(e,c)
end
function c40008517.TuneMagicianCheckX(c,sg,ecode)
	local eset={c:IsHasEffect(ecode)}
	for _,te in pairs(eset) do
		if sg:IsExists(c40008517.TuneMagicianFilter,1,c,te) then return true end
	end
	return false
end
function c40008517.GetMustMaterialGroup(tp,code)
	local g=Group.CreateGroup()
	local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
	for _,te in ipairs(ce) do
		local tc=te:GetHandler()
		if tc then g:AddCard(tc) end
	end
	return g
end
function c40008517.MustMaterialCheck(v,tp,code)
	local g=c40008517.GetMustMaterialGroup(tp,code)
	if not v then
		if code==EFFECT_MUST_BE_XMATERIAL and Duel.IsPlayerAffectedByEffect(tp,67120578) then return false end
		return #g==0
	end
	local t=c40008517.GetValueType(v)
	for tc in c40008517.Next(g) do
		if (t=="Card" and v~=tc)
			or (t=="Group" and not v:IsContains(tc)) then return false end
	end
	return true
end
function c40008517.Next(g)
	local first=true
	return  function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function c40008517.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "Group"
		elseif mt==Effect then return "Effect"
		else return "Card" end
	else return t end
end
function c40008517.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c40008517.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008517.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008517.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008517.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008517.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008517.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008517.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c40008517.thfilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToHand()
end
function c40008517.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008517.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008517.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40008517.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40008517.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c40008517.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and not re:GetHandler():IsType(TYPE_TOON)
		and Duel.IsChainNegatable(ev)
end
function c40008517.filter(c)
	return c:IsSetCard(0x62)
end
function c40008517.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008517.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40008517.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c40008517.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end