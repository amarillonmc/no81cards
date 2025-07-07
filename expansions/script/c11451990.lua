--蓝色链接
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsLinkState() and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup():Filter(cm.rffilter,nil)
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retfilter2(c,p,loc)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=e:GetLabelObject()
		local sg=g:Filter(cm.retfilter,nil,e:GetLabel())
		g:DeleteGroup()
		local ft,mg,ng={},{},Group.CreateGroup()
		ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
		ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
		ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
		mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
		mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
		mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
		for i=1,4 do
			if #mg[i]>ft[i] then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
				local rg=mg[i]-tg
				sg:Sub(rg)
				ng:Merge(rg)
			end
		end
		for tc in aux.Next(sg) do
			if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
				Duel.ReturnToField(tc)
				--Duel.MoveToField(tc,tp,tc:GetPreviousControler(),tc:GetPreviousLocation(),tc:GetPreviousPosition(),true)
			elseif tc:IsPreviousLocation(LOCATION_HAND) then
				Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
			end
		end
		Duel.SendtoGrave(ng,REASON_RULE+REASON_RETURN)
		e:Reset()
	end
end