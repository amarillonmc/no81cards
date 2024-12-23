--天枰刻印
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.check then cm.check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(eg) do
		if tc:GetType()==TYPE_SPELL and aux.IsCodeListed(tc,60000163) then
			Duel.RegisterFlagEffect(tc:GetOwner(),m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.fil1(c)
	return c:IsDiscardable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,m)>0 then b2=true end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD) end
	e:SetLabel(op)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if not Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_HAND,0,1,nil) or not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		if Duel.DiscardHand(tp,cm.fil1,1,1,REASON_EFFECT,nil)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
			if g:GetFirst():IsControler(tp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g:GetFirst()) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetFirst()):Select(tp,1,1,nil)
				g:Merge(sg)
			end
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif op==2 then
		if not Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_GRAVE,0,1,nil) or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or Duel.GetFlagEffect(tp,m)==0 then return end
		local num=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),Duel.GetFlagEffect(tp,m))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.GetMatchingGroup(cm.fil2,tp,LOCATION_GRAVE,0,nil):Select(tp,1,num,nil)
		Duel.SSet(tp,g)
	end
end















