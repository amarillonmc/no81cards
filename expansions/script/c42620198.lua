--姬丝基勒完播
local cm,m=GetID()

function cm.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
end

function cm.tgsfilter(c)
    return c:IsLevelAbove(1) and c:IsFaceup()
end

function cm.tgsffilter(c,tc)
    return c:GetLevel()==tc:GetLevel() and c:GetAttribute()~=tc:GetAttribute()
end

function cm.tgsgfilter(c,e,tp,g)
    return c:IsCanBeSpecialSummoned(e,POS_FACEUP_DEFENSE,tp,false,false) and g:IsExists(cm.tgsffilter,1,nil,c)
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(cm.tgsfilter,tp,0x04,0,nil)
    if chkc then return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tgsgfilter(chkc,e,tp,g) end
    if chk==0 then return #g>0 and Duel.IsExistingTarget(cm.tgsgfilter,tp,0x10,0,1,nil,e,tp,g) and Duel.GetLocationCount(tp,0x04)>0 and Duel.IsPlayerCanDraw(tp,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,cm.tgsgfilter,tp,0x10,0,1,1,nil,e,tp,g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp)
    local tc,c=Duel.GetFirstTarget(),e:GetHandler()
    if c:IsRelateToChain() and tc:IsRelateToChain() and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		c:RegisterEffect(e1)
        --Destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_LEAVE_FIELD_P)
		e3:SetOperation(cm.checkop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e4:SetCode(EVENT_LEAVE_FIELD)
		e4:SetOperation(cm.desop)
		e4:SetReset(RESET_EVENT+RESET_OVERLAY+RESET_TOFIELD)
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
        if Duel.SpecialSummonComplete() then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end

function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end