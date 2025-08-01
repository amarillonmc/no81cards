--魔人★双子使徒 小雪
local cm,m=GetID()
function cm.initial_effect(c)
	--Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.recost)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.thcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,2,REASON_COST,true,nil,RACE_FAIRY) or (Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,REASON_COST,true,nil,RACE_FAIRY) and Duel.IsPlayerAffectedByEffect(tp,11451482)) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		if Duel.CheckReleaseGroupEx(tp,Card.IsRace,2,REASON_COST,true,nil,RACE_FAIRY) then
			op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451482,0,0,1)
				Duel.ResetFlagEffect(tp,11451481)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,2-op,2-op,REASON_COST,true,nil,RACE_FAIRY)
	aux.UseExtraReleaseCount(g,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabel(op)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local op=e:GetLabel()
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451482)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function cm.cfilter(c)
	return c:GetSequence()<5 and c:IsAbleToRemove()
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_SZONE,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function cm.thfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_OVERLAY) --and c:GetPreviousControler()==tp
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.IsPlayerCanRelease(1-tp) and g:IsExists(Card.IsReleasable,1,nil,1-tp) and #g>2 and Duel.GetFlagEffect(tp,m)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) --or (Duel.IsPlayerAffectedByEffect(tp,11451482) and #g>2)) end
	local op=0
	if Duel.IsPlayerAffectedByEffect(tp,11451482) then
		op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
		if op==1 then
			Duel.RegisterFlagEffect(tp,11451482,0,0,1)
			Duel.ResetFlagEffect(tp,11451481)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451482)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g-2+op,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRelease(1-tp) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g<=2 then return end
	local op=e:GetLabel()
	local ct=#g-2+op
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:FilterSelect(1-tp,Card.IsReleasable,ct,ct,nil,1-tp)
		Duel.Release(sg,REASON_RULE)
	end
end