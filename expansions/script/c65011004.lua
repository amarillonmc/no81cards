--以斯拉的激斗 六日鏖战
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011004,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1})
	local e2=rsef.FV_INDESTRUCTABLE(c,"ct",rsval.indct("effect"),cm.tg,{LOCATION_ONFIELD,0})
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(rshint.neg)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e4=rsef.FC(c,EVENT_BE_MATERIAL,nil,nil,nil,LOCATION_SZONE,cm.regcon,cm.regop)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,nil) and r & (REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK) ~=0 
end
function cm.cfilter2(c)
	local rc=c:GetReasonCard()
	return rc:GetSummonLocation()==LOCATION_EXTRA and c:GetOwner()~=c:GetPreviousControler() and rsisr.IsPreSet(c)
end
function cm.regop(e,tp,eg)
	local c=e:GetHandler()
	local rg=eg:Filter(cm.cfilter2,nil)
	for tc in aux.Next(rg) do
		local rc=tc:GetReasonCard()
		if rc:GetFlagEffect(m)<=0 then
			rc:RegisterFlagEffect(m,rsreset.est,0,1)
			local e1=rsef.STF(rc,EVENT_SPSUMMON_SUCCESS,nil,nil,"rm","cd",nil,nil,rsop.target(aux.TRUE,"rm"),cm.rmop,rsreset.est)
			if not rc:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e2,true)
			end
		end
	end
end
function cm.rmop(e,tp)
	local c=rscf.GetSelf(e)
	if c then  
		rshint.Card(m)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end 
function cm.tg(e,c)
	return rsisr.IsSet(c) and c~=e:GetHandler()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and rsisr.IsSet(c) and c:IsType(TYPE_LINK)
end
function cm.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,0,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		rsop.SelectOC("des")
		rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,{})
	end
end