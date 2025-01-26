--神乐谐奏
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,500)
end
function s.thfilter(c)
	return c:IsSetCard(0xca70) and c:IsAbleToRemove()
end
function s.ovfilter(c)
	return c:IsSetCard(0xca70) and c:IsFaceup() and c:IsCanOverlay()
end
function s.cfilter(c)
	return c:IsSetCard(0xaa70) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local c=e:GetHandler()
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and Duel.Recover(1-tp,500,REASON_EFFECT)>0 then
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil)
		if cl==2 and #tg>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=tg:Select(tp,1,1,nil)
			if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_REMOVED) then 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ovfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if cl==6 and #g>0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg2=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local tc=sg2:GetFirst()
			Duel.Overlay(tc,sg1)
		end
	end
end
