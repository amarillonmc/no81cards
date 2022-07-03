local m=189119
local cm=_G["c"..m]
cm.name="恒夜骑士-咎灵之莱拉"
function cm.initial_effect(c)
	cm.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_SPIRIT),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(function(e)
		local ph=Duel.GetCurrentPhase()
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end)
	e3:SetValue(cm.aclimit)
	c:RegisterEffect(e3)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),eg:GetFirst()
	local ph=Duel.GetCurrentPhase()
	if ph<PHASE_BATTLE_START or ph>PHASE_BATTLE or ep~=tp or not tc:IsType(TYPE_SPIRIT) or not tc:IsOnField() or not tc:IsCanOverlay() or Duel.GetFlagEffect(tp,m)>0 or Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(SUMMON_TYPE_SPECIAL)
	c:RegisterEffect(e1)
	local g=Group.FromCards(c,tc)
	g:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(g)
	e2:SetOperation(cm.xyzop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_NEGATED)
	e3:SetOperation(cm.rstop)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e3,tp)
	Duel.SpecialSummonRule(tp,c,SUMMON_TYPE_SPECIAL)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc,c=g:GetFirst(),g:GetNext()
	if eg:GetFirst()~=c or not c:IsType(TYPE_XYZ) or not tc:IsCanOverlay() then return end
	local og=tc:GetOverlayGroup()
	if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
	Duel.Overlay(c,Group.FromCards(tc))
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanOverlay),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.aclimit(e,re,tp)
	if not e:GetHandler():IsType(TYPE_XYZ) then return false end
	local g=e:GetHandler():GetOverlayGroup()
	if #g==0 then return false end
	local typ=0
	for tc in aux.Next(g) do typ=typ|tc:GetType() end
	return re:IsActiveType(typ)
end
function cm.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	e1:SetCondition(cm.XyzCondition(f,lv,ct,maxct))
	e1:SetTarget(aux.XyzTarget(f,lv,ct,maxct))
	e1:SetOperation(aux.XyzOperation(f,lv,ct,maxct))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function cm.XyzCondition(f,lv,minc,maxc)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local ph=Duel.GetCurrentPhase()
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
			end
end
