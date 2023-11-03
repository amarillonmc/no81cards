local m=53796143
local cm=_G["c"..m]
cm.name="电子光虫-驱动大刀螳"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,cm.matfilter,3,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		Mantriver_CRemoveOverlayCard=Card.RemoveOverlayCard
		Card.RemoveOverlayCard=function(tc,tp,minc,maxc,reason)
			Mantriver_Mat_Check={Group.FromCards(tc),minc,maxc}
			local op=Mantriver_CRemoveOverlayCard(tc,tp,minc,maxc,reason)
			Mantriver_Mat_Check=nil
			return op
		end
		Mantriver_DRemoveOverlayCard=Duel.RemoveOverlayCard
		Duel.RemoveOverlayCard=function(tp,s,o,minc,maxc,reason)
			local self,oppo=0 or (s==1 and LOCATION_MZONE),0 or (o==1 and LOCATION_MZONE)
			Mantriver_Mat_Check={Duel.GetFieldGroup(tp,self,oppo),minc,maxc}
			local op=Mantriver_DRemoveOverlayCard(tp,s,o,minc,maxc,reason)
			Mantriver_Mat_Check=nil
			return op
		end
	end
end
function cm.matfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.mfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsLocation(LOCATION_MZONE))
end
function cm.xyzcheck(g,c,tp,mg1,min,max)
	local ct=Group.__band(g,mg1):GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ct>=min and ct<=max and c:IsXyzSummonable(g) and ft>0 and g:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_MZONE)<=ft
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetOwnerPlayer()
	if ep~=p or Duel.GetFlagEffect(p,m)>0 or not Mantriver_Mat_Check then return false end
	local g,min,max=table.unpack(Mantriver_Mat_Check)
	local mg1=Group.CreateGroup()
	for tc in aux.Next(g) do mg1:Merge(tc:GetOverlayGroup()) end
	mg1=mg1:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,p,false,false)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,p,LOCATION_HAND+LOCATION_MZONE,0,nil,e,p)
	local mg=Group.__add(mg1,mg2)
	return Duel.IsPlayerCanSpecialSummonCount(p,2) and not Duel.IsPlayerAffectedByEffect(p,59822133) and mg:CheckSubGroup(cm.xyzcheck,3,3,c,tp,mg1,min,max)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetOwnerPlayer()
	Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
	local g,min,max=table.unpack(Mantriver_Mat_Check)
	local mg1=Group.CreateGroup()
	for tc in aux.Next(g) do mg1:Merge(tc:GetOverlayGroup()) end
	mg1:KeepAlive()
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(aux.FALSE)
	e1:SetOperation(cm.mtop)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop(mg1,min,max))
	if r&REASON_COST~=0 and re:IsActivated() then
		e2:SetType(EFFECT_TYPE_QUICK_F)
		e2:SetCode(EVENT_CHAINING)
		e2:SetReset(RESET_EVENT+0xfe0000+RESET_CHAIN)
		c:RegisterEffect(e2,true)
	else
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_CUSTOM+m)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetReset(RESET_EVENT+0xfe0000+RESET_CHAIN)
		c:RegisterEffect(e2,true)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
	Duel.Hint(HINT_CARD,0,m)
	Duel.ConfirmCards(1-tp,c)
	return max
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	 e:SetValue(SUMMON_TYPE_XYZ)
	 local mg=e:GetLabelObject()
	 local sg=Group.CreateGroup()
	 for tc in aux.Next(mg) do
		 if tc:IsLocation(LOCATION_MZONE) then sg:Merge(tc:GetOverlayGroup()) end
	 end
	 Duel.SendtoGrave(sg,REASON_RULE)
	 c:SetMaterial(mg)
	 Duel.Overlay(c,mg)
	 mg:DeleteGroup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_OVERLAY+LOCATION_EXTRA)
end
function cm.spop(mg1,min,max)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local te=e:GetLabelObject()
				te:SetCondition(aux.TRUE)
				if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and c:IsSpecialSummonable(SUMMON_VALUE_SELF)then
					mg1=mg1:Filter(Card.IsLocation,nil,LOCATION_OVERLAY)
					mg1=mg1:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
					local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e,tp)
					local mg=Group.__add(mg1,mg2)
					local sg=mg:SelectSubGroup(tp,cm.xyzcheck,false,3,3,c,tp,mg1,min,max)
					if sg then
						local spg=sg:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_MZONE)
						local ct=Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
						Duel.AdjustAll()
						if spg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==ct then
							sg:KeepAlive()
							e:GetLabelObject():SetLabelObject(sg)
							Duel.SpecialSummonRule(tp,c,SUMMON_VALUE_SELF)
						else te:Reset() end
					else te:Reset() end
				else te:Reset() end
				e:Reset()
	end
end
function cm.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOriginalRank()<=7 and c:IsRace(RACE_INSECT)
end
function cm.matfilter(c)
	return c:IsCanOverlay()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) or (Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_MZONE,0,1,nil) and g:IsExists(cm.matfilter,1,nil)) end
	local op=aux.SelectFromOptions(tp,{c:CheckRemoveOverlayCard(tp,1,REASON_COST),aux.Stringid(m,3),1},{Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_MZONE,0,1,nil) and g:IsExists(cm.matfilter,1,nil),aux.Stringid(m,4),2})
	if op==1 then c:RemoveOverlayCard(tp,1,1,REASON_COST) elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,cm.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,cm.matfilter,1,1,nil)
		Duel.Overlay(tc,sg)
	end
end
function cm.desfilter(c,e,tp,ct)
	return (Duel.IsExistingMatchingCard(cm.spfilter,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,1-tp) or (ct==0 and Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),1-tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanSpecialSummon(1-tp))) and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and (c:IsPublic() or c:IsLocation(LOCATION_GRAVE))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffect(m)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp,ct) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,loc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local loc=LOCATION_GRAVE
		local c=e:GetHandler()
		if c:GetFlagEffect(m)==0 then loc=loc|LOCATION_HAND end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),1-tp,loc,0,1,1,nil,e,0,1-tp,false,false,POS_FACEUP_DEFENSE):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			if tc:IsPreviousLocation(LOCATION_HAND) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
			if not tc:IsLocation(LOCATION_MZONE) then return end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_BATTLED)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetOwnerPlayer(tp)
			e3:SetReset(RESET_EVENT+0x17a0000)
			e3:SetOperation(cm.baop)
			tc:RegisterEffect(e3,true)
		end
	end
end
function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetOwnerPlayer()
	if not d or c~=d or a:GetControler()~=p or not c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+0x17a0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(e:GetOwner())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(a)
	e4:SetOperation(cm.operation)
	Duel.RegisterEffect(e4,p)
end
function cm.damfilter(c)
	return c:IsLocation(LOCATION_GRAVE)and c:IsReason(REASON_BATTLE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.damfilter,1,nil) then
		local tc=e:GetLabelObject()
		Duel.Damage(1-e:GetOwnerPlayer(),tc:GetRank()*tc:GetOverlayCount()*100,REASON_EFFECT)
	end
	e:Reset()
end
