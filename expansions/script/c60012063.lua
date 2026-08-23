-- 龙之启示
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.fil(c)
	return c:IsSummonable(true,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local exsum=Duel.GetFlagEffect(tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Summon(tp,tc,true,nil)~=0 and exsum~=0 then
		local checksum=true
		for i=1,exsum do
			if checksum==true and not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then checksum=false end
			if not Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then return end
			if checksum==false then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.Summon(tp,tc,true,nil)
				end
		end
	end
end
function cm.td(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end