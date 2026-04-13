--幽冥守护者·塔希提
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
	--def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.xmatcon)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	--if not g or g:GetCount()~=1 then return false end
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	--e:SetLabelObject(tc)
	return tc:IsOnField() and tc:IsSetCard(0xd70) and tc:IsControler(tp) and tc:IsFaceup()
end
function s.filter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
--[[
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,id)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	if chkc then return chkc:IsOnField() and s.filter(chkc,ct) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),ct)
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,id,val)
	else
		Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,val)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end]]--
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--local tc=Duel.GetFirstTarget()
		--if tc:IsRelateToEffect(e) then
			Duel.ChangeTargetCard(ev,Group.FromCards(c))
		--end
	end
end

function s.atlimit(e,c)
	return c~=e:GetHandler()
end

function s.xmatcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd70) and c:IsType(TYPE_XYZ)
end
function s.val(e,c)
	local c=e:GetHandler()
	return c:GetRank()*100
end