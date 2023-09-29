local m=53715001
local cm=_G["c"..m]
cm.name="欢乐树友 哑剧"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.HTFSynchoro(c,0,m)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.filter(c,ft,e,tp)
	return not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_PENDULUM) and (((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden()) or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,ft,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
			for tc in aux.Next(sg) do
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				local sp=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				local pl=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not tc:IsForbidden()
				local op=0
				if sp and pl then op=Duel.SelectOption(tp,1152,aux.Stringid(m,2))
				elseif sp then op=0
				else op=1 end
				if op==0 then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				end
			end
		end
	end
	SNNM.HTFPlacePZone(c,4,LOCATION_GRAVE,0,EVENT_FREE_CHAIN,m,tp)
end
