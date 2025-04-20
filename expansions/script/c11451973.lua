--秘计螺旋 耗尽
local cm,m=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(11451971)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(cm.adop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHandAsCost()
end
function cm.fselect(g)
	return g:GetFirst():GetType()&(TYPE_SPELL+TYPE_TRAP)~=g:GetNext():GetType()&(TYPE_SPELL+TYPE_TRAP)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	local hg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,0,nil)
	return #hg>0 and g:CheckSubGroup(cm.fselect,2,2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	local hg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,true,2,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg2=hg:Select(tp,1,1,nil)
	if #sg>0 and #sg2>0 then
		sg:Merge(sg2)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local sg=g:Filter(Card.IsOnField,nil)
	Duel.SendtoGrave(g-sg,REASON_SPSUMMON+REASON_COST)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	g:DeleteGroup()
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	DEFECT_ORAL_COUNT=DEFECT_ORAL_COUNT or 3
	local ct=3+2*#{Duel.IsPlayerAffectedByEffect(0,11451971)}-#{Duel.IsPlayerAffectedByEffect(0,11451973)}
	if DEFECT_ORAL_COUNT<ct then
		DEFECT_ORAL_COUNT=ct
	elseif DEFECT_ORAL_COUNT>ct then
		DEFECT_ORAL_COUNT=ct
		for tp=0,1 do
			local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
			while #eset>DEFECT_ORAL_COUNT do
				local de=eset[#eset]
				local ce=de:GetLabelObject()
				if ce and aux.GetValueType(ce)=="Effect" then
					local tc=ce:GetHandler()
					local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
					local res=false
					for _,te in pairs(eset2) do
						if te:GetLabel()==de:GetLabel() then res=true break end
					end
					if res then
						Duel.RaiseEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0)
						Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(tc:GetOriginalCode(),3))
						Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(tc:GetOriginalCode(),3))
					end
					ce:Reset()
				end
				de:Reset()
				eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
			end
		end
	end  
end