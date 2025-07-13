--不在场论证
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check={}
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetOperation(cm.gop)
		Duel.RegisterEffect(e3,0)
	end
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local tab=cm.global_check
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(g) do
		local code,code2=tc:GetCode()
		tab[code]=tab[code] or {}
		if code2 then tab[code2]=tab[code2] or {} end
	end
	for code,_ in pairs(tab) do
		for code2,_ in pairs(tab) do
			tab[code][code2]=true
		end
	end
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,e,tp)
	local tab=cm.global_check
	local code,code2=g:GetFirst():GetCode()
	if not code2 then code2=code end
	local code3,code4=g:GetNext():GetCode()
	if not code4 then code4=code3 end
	return g:IsExists(cm.spfilter,1,nil,e,tp) and (tab[code] or tab[code2]) and (tab[code3] or tab[code4]) and (not tab[code] or (not tab[code][code3] and not tab[code][code4])) and (not tab[code2] or (not tab[code2][code3] and not tab[code2][code4]))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tgfilter(chkc,e) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>1 and g:CheckSubGroup(cm.fselect,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(cm.spfilter,nil,e,tp)
	if e:GetHandler():IsRelateToEffect(e) and #tg>0 and Duel.GetMZoneCount(tp)>0 then
		local c=tg:GetFirst()
		local tc
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			c=tg:Select(tp,1,1,nil):GetFirst()
			tg:RemoveCard(c)
			tc=tg:GetFirst()
		end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,e:GetHandler(),c)
		--Add Equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(c)
		e:GetHandler():RegisterEffect(e1)
		if tc then
			--copy effect
			local code=tc:GetOriginalCodeRule()
			local cid=0
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetValue(code)
			c:RegisterEffect(e2)
			code=tc:GetOriginalCode()
			if tc:GetOriginalType()&TYPE_EFFECT>0 then
				cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			end
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,cid)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,cid)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(1162)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_ADJUST)
			e3:SetLabel(cid)
			e3:SetLabelObject(e2)
			e3:SetOperation(cm.rstop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	local e2=e:GetLabelObject()
	if aux.GetValueType(e2)~="Effect" then e:Reset() return end
	local tc=e2:GetHandler()
	if not tc or tc:GetFlagEffect(m)==0 then e:Reset() return end
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 or c:GetEquipTarget()~=tc then
		if cid~=0 then
			tc:ResetEffect(cid,RESET_COPY)
			tc:ResetEffect(RESET_DISABLE,RESET_EVENT)
		end
		e2:Reset()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:Reset()
	end
end