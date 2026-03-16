local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	
	--limit (这个效果不会被无效化)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCode(EFFECT_MAX_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.mvalue)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MAX_SZONE)
	e2:SetValue(s.svalue)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetValue(s.aclimit)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetTarget(s.setlimit)
	c:RegisterEffect(e4)
	
	--adjust (必须送去墓地)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.adjustop)
	c:RegisterEffect(e5)
	
	--standby phase effect
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(s.efftg)
	e6:SetOperation(s.effop)
	c:RegisterEffect(e6)
end

function s.mvalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 7 end
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local sct=Duel.GetFieldGroupCount(fp,LOCATION_SZONE+LOCATION_FZONE,0)
	return math.max(ct-sct,0)
end
function s.svalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 7 end
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local mct=Duel.GetFieldGroupCount(fp,LOCATION_MZONE+LOCATION_FZONE,0)
	return math.max(ct-mct,0)
end
function s.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if not re:IsActiveType(TYPE_FIELD) then return false end
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local fct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	-- 如果已有场地魔法，发动新场地会将旧场地送墓，卡片总数不会增加，故不加限制
	return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and fct>=ct
end
function s.setlimit(e,c,tp)
	if not c:IsType(TYPE_FIELD) then return false end
	local hc=e:GetHandler()
	local ct=hc:GetOverlayCount()
	local fct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return not Duel.GetFieldCard(tp,LOCATION_FZONE,0) and fct>=ct
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local sg=Group.CreateGroup()
	if g1:GetCount()>ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg1=g1:SelectSubGroup(tp,aux.TRUE,false,g1:GetCount()-ct,g1:GetCount()-ct)
		if tg1 then sg:Merge(tg1) end
	end
	if g2:GetCount()>ct then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tg2=g2:SelectSubGroup(1-tp,aux.TRUE,false,g2:GetCount()-ct,g2:GetCount()-ct)
		if tg2 then sg:Merge(tg2) end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE,0,1,nil) and c:IsType(TYPE_XYZ)
	local res=false
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(nil),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
			res=true
		end
	end
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		if res then Duel.BreakEffect() end
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end