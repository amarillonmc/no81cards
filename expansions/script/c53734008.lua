local m=53734008
local cm=_G["c"..m]
cm.name="结青缀 星野航"
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(cm.rmcon)
	e2:SetCost(cm.rmcost)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	if not cm.Aozora_Check then
		cm.Aozora_Check=true
		cm[0]=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			cm[0](e,p)
		end
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),0,0
				if e:GetRange() then range=e:GetRange() end
				if e:GetCondition() then con=e:GetCondition() end
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					cm[1](c,ex)
					cm[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			cm[1](c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=cm[e][1],cm[e][2],cm[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local dis=cm.WataruZone(tp)
	if chk==0 then return dis~=0 and cm.WataruSP(c,e,tp,dis) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dis=cm.WataruZone(tp)
	if dis==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetValue(RACE_FAIRY)
	e0:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e0)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,dis)~=0 then
		if not c:IsLocation(LOCATION_MZONE) then return end
		if e0 then
			e0:SetProperty(0)
			e0:SetRange(LOCATION_MZONE)
		end
		local st,cs={},c:GetSequence()
		if cs>0 then table.insert(st,cs-1) end
		if cs<4 then table.insert(st,cs+1) end
		if #st==0 then return end
		local z=0
		for i=1,#st do
			local cz=1<<st[i]
			if cz&SNNM.DisMZone(tp)>0 then z=z|cz end
		end
		SNNM.ReleaseMZone(e,tp,z)
	elseif e0 then e0:Reset() end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3536) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.WataruSP(c,e,tp,dis)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetValue(RACE_FAIRY)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
	local res=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,dis)
	e0:Reset()
	return res
end
function cm.WataruZone(tp)
	local s={}
	for i=0,4 do
		local z=1<<i
		if tp==1 then z=1<<(i+16) end
		local x=i
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				if val then
					if aux.GetValueType(val)=="function" then
						if z&val(te)>0 then table.insert(s,x) end
					else
						if z&val>0 then table.insert(s,x) end
					end
				end
			end
		end
	end
	if #s==0 then return false end
	local zone=0
	for i=1,#s do
		local seq=s[i]
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|(1<<(seq+1)) end
	end
	return zone
end
