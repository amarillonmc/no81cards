--Ｔ．Ｔ．Ｂ
local m=33703048
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddFusionProcFunRep(c,cm.matfilter,2,true)
	--aux.AddFusionProcCodeFun(c,nil,cm.matfilter,3,true,true)
	--aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--calu
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetRange(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
	e0:SetCondition(cm.calcon)
	e0:SetOperation(cm.calop)
	e0:SetLabel(0)
	e0:SetReset(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	--c:RegisterEffect(e1)
	--special summon rule
	
	--spsum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e0)
end
function cm.calcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function cm.calop(e,tp,eg,ep,ev,re,r,rp)
	local tc = eg:GetFirst()
	local g =Group.CreateGroup()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ+TYPE_LINK+TYPE_RITUAL) then
			g:AddCard(tc)
		end
		tc=eg:GetNext()
	end
	if g:GetCount()~=0 then
		local temp=e:GetLabel()
		e:SetLabel(temp+1)
	end
	
end

function cm.matfilter(c,fc,sub,mg,sg)
	return true
end
function cm.splimit(e)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function cm.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0 and Duel.GetTurnPlayer()==tp 
end
function cm.rem(g)
	return g:GetClassCount(Card.GetCode)==1 and g:GetCount()==3
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp)
	local bt =Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,3,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,nil)
	if bt~=0 then
	 if g:CheckSubGroup(cm.rem,1,3) then
		--if temp:GetClassCount(Card.GetCode)==1  then 
			if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					if #g<3 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,cm.rem,false,1,3)
		if #sg==0 then return end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
				if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) then
					if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)~=0 then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_SET_ATTACK)
						e1:SetValue(e:GetLabelObject():GetLabel()*2000)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e:GetHandler():RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_SET_DEFENSE)
						e2:SetValue(e:GetLabelObject():GetLabel()*2000)
						e:GetHandler():RegisterEffect(e2)
					end
				end
			end 
		--end
	 end
	end

end
function cm.spfilter(c)
	return c:IsType(TYPE_MONSTER)
end	
