local m=53799219
local cm=_G["c"..m]
cm.name="萤火虫哒"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_ALLOW_SYNCHRO_KOISHI)
	e2:SetValue(function(e,c)return e:GetHandler():GetRank()end)
	c:RegisterEffect(e2)
end
function cm.filter(c,e)
	return c:IsFaceup() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(cm.fselect,2,#g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,2,#g)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and #tg~=0 then
		Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		if not c:IsLocation(LOCATION_MZONE) or not tg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return end
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetLabel(tc:GetLevel())
			e1:SetValue(function(e,c,rc)return e:GetHandler():GetLevel()+0x10000*e:GetLabel()end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			c:RegisterEffect(e1)
		end
		tg:AddCard(c)
		tg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,tg,#tg,#tg)
		if Duel.IsPlayerCanSpecialSummonCount(tp,2) and #xyzg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,tg)
		end
	end
end
