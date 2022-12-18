local m=53750009
local cm=_G["c"..m]
cm.name="远乐之森的素士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc~=e:GetHandler() and tc:IsFaceup() and tc:IsType(TYPE_EFFECT)
end
function cm.cfilter(c,e,tp,tc)
	if not c:IsSetCard(0x9532) or c:GetType()~=TYPE_SPELL or not c:GetActivateEffect() then return false end
	local le={c:GetActivateEffect()}
	local check=false
	for _,te in pairs(le) do
		local e1=te:Clone()
		e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAINING)
		local pro,pro2=te:GetProperty()
		pro=pro|EFFECT_FLAG_DAMAGE_STEP
		pro=pro|EFFECT_FLAG_DAMAGE_CAL
		e1:SetProperty(pro,pro2)
		e1:SetCost(cm.accost)
		tc:RegisterEffect(e1,true)
		local te,ceg,cep,cev,cre,cr,crp=c:CheckActivateEffect(true,true,true)
		local flag=false
		if tc:IsReleasable() and (not ftg or ftg(e1,tp,ceg,cep,cev,cre,cr,crp,0)) and not c:IsHasEffect(EFFECT_CANNOT_TRIGGER) then
			local bool=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)
			local re={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
			if bool then
				for k,v in ipairs(re) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="function" then
						val=val(v,e1,tp)
						if not val then flag=true end
					elseif val~=1 then flag=true end
				end
			else flag=true end
		end
		if flag then check=true end
		e1:Reset()
	end
	return check and c:IsAbleToGraveAsCost()
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=eg:GetFirst()
	if not rc:IsLocation(LOCATION_MZONE) or rc:IsFacedown() then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,rc:GetControler(),rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,rc:GetControler(),rc):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	if rc:IsType(TYPE_EFFECT) and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(rc)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetLabelObject(tc)
		e1:SetCost(cm.accost)
		e1:SetTarget(cm.actg)
		e1:SetOperation(cm.acop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		rc:RegisterEffect(e1,true)
	end
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={e:GetLabelObject():GetActivateEffect()}
	local check=false
	if chk==0 then
		e:SetCostCheck(false)
		for _,te in pairs(le) do
			local ftg=te:GetTarget()
			if (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) then check=true end
		end
		return check
	end
	local off=1
	local ops={}
	local opval={}
	for i,te in pairs(le) do
		local tg=te:GetTarget()
		e:SetCostCheck(false)
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			local des=te:GetDescription()
			if des then ops[off]=des else ops[off]=aux.Stringid(m,2) end
			opval[off-1]=i
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local s=opval[op]
	e:SetLabel(s)
	local ae=le[s]
	local cat=ae:GetCategory()
	if cat then e:SetCategory(cat) else e:SetCategory(0) end
	local pro,pro2=ae:GetProperty()
	pro=pro|EFFECT_FLAG_DAMAGE_STEP
	pro=pro|EFFECT_FLAG_DAMAGE_CAL
	e:SetProperty(pro,pro2)
	local etg=ae:GetTarget()
	if etg then
		e:SetCostCheck(false)
		etg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local le={e:GetLabelObject():GetActivateEffect()}
	local ae=le[e:GetLabel()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST)
	local rc=eg:GetFirst()
	if rc:IsType(TYPE_EFFECT) and tc:IsLocation(LOCATION_REMOVED) and tc:GetActivateEffect() then
		if rc:GetFlagEffect(m)==0 then rc:RegisterFlagEffect(m,RESET_CHAIN,0,1) end
		local le={tc:GetActivateEffect()}
		local ct=#le
		local ch=Duel.GetCurrentChain()
		for i,te in pairs(le) do
			local e1=Effect.CreateEffect(rc)
			if ct==1 then e1:SetDescription(aux.Stringid(m,2)) else e1:SetDescription(te:GetDescription()) end
			e1:SetCategory(te:GetCategory())
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
			e1:SetProperty(te:GetProperty())
			e1:SetLabel(1<<ch)
			e1:SetLabelObject(tc)
			e1:SetValue(i)
			e1:SetTarget(cm.spelltg)
			e1:SetOperation(cm.spellop)
			e1:SetReset(RESET_CHAIN)
			rc:RegisterEffect(e1)
		end
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m)
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,e:GetLabel())==0
	end
	e:GetHandler():SetFlagEffectLabel(m,flag|e:GetLabel())
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsLocation(LOCATION_MZONE) and eg:GetFirst():IsAbleToHand() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
