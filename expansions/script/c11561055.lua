--炽热之翼 公主·日和莉
local m=11561055
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11561055.xyzcondition)
	e1:SetTarget(c11561055.xyztarget)
	e1:SetOperation(c11561055.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--count 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c11561055.cacon)
	e2:SetTarget(c11561055.catg)
	e2:SetOperation(c11561055.caop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11561055.atkcon)
	e3:SetOperation(c11561055.atkop)
	c:RegisterEffect(e3)
	--cannot announce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c11561055.antarget)
	c:RegisterEffect(e4)
	
end
function c11561055.antarget(e,c)
	return c~=e:GetHandler()
end
function c11561055.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	return a==e:GetHandler() and d and d:IsFaceup() and not d:IsControler(tp) and  e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0
end
function c11561055.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker():GetBattleTarget()
	local og=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=og:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
	Duel.SendtoGrave(rg,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsType(TYPE_MONSTER) and c:IsRelateToBattle() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(tc:GetBaseAttack()/2)
		c:RegisterEffect(e1)
		if d:IsRelateToBattle() and d:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(-tc:GetBaseAttack()/2)
			d:RegisterEffect(e2)
		end
		end
	if not c:IsRelateToBattle() then return end
	--Duel.ChainAttack()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(function() Duel.ChainAttack() end)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e3)
end
function c11561055.cacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11561055.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
end
function c11561055.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=c:GetOverlayGroup()
		if og:GetCount()==0 then return end
		c:AddCounter(0x1,og:GetCount())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(og:GetCount()*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c11561055.lfilter(c)
	return not c:IsLocation(LOCATION_MZONE)
end
function c11561055.nafilter(c)
	local tp=c:GetControler()
	local loc=0x77&(~c:GetLocation())
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c11561055.nafilter2,tp,loc,0,1,c,c:GetCode(),c)
end
function c11561055.nafilter2(c,code,tc)
	local tp=c:GetControler()
	local loc=0x77&(~c:GetLocation())&(~tc:GetLocation())
	return c:IsCode(code) and Duel.IsExistingMatchingCard(Card.IsCode,tp,loc,0,1,c,code)
end
function c11561055.nafilter3(c,tp,ccodes)
	return Duel.IsExistingMatchingCard(c11561055.nafilter2,tp,0x77,0,3,nil,c:GetCode()) and c:IsCode(table.unpack(ccodes))
end
function c11561055.xyzcheck(g,tp,xyzc)
	return g:GetClassCount(Card.GetCode)==1 and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 and g:Filter(c11561055.lfilter,nil):GetClassCount(Card.GetLocation)==g:FilterCount(c11561055.lfilter,nil) and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end
function c11561055.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetMatchingGroup(c11561055.nafilter,tp,0x77,0,nil)
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(c11561055.xyzcheck,3,99,tp,c)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c11561055.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	else
		mg=Duel.GetMatchingGroup(c11561055.nafilter,tp,0x77,0,nil)
		--local tg=Duel.GetMatchingGroup(c11561055.nafilter,tp,LOCATION_MZONE,0,nil,tp,codes)
		--local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil,tp)
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	g=mg:SelectSubGroup(tp,c11561055.xyzcheck,cancel,3,99,tp,c)
	Auxiliary.GCheckAdditional=nil
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c11561055.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		mg=og
	else
		mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
		end
	Duel.SendtoGrave(sg,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
