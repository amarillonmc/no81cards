--异梦刺青妹妹
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400068.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c71400068.matfilter,1,1,yume.YumeCheck(c))
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c71400068.regcon)
	e0:SetOperation(c71400068.regop)
	c:RegisterEffect(e0)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c71400068.atktg)
	e1:SetValue(c71400068.atkval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400068,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71400068)
	e2:SetCondition(c71400068.con2)
	e2:SetTarget(c71400068.tg2)
	e2:SetOperation(c71400068.op2)
	c:RegisterEffect(e2)
end
function c71400068.matfilter(c)
	return c:IsSetCard(0x714) and c:IsLevelBelow(4)
end
function c71400068.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71400068.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c71400068.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c71400068.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(25725326) and sumtype & SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
function c71400068.atktg(e,c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsSetCard(0x714)
end
function c71400068.atkval(e,c)
	return c:GetAttack()*2
end
function c71400068.filter2con(c,tp)
	return c:IsPreviousSetCard(0x714) and c:IsType(TYPE_LINK)
end
function c71400068.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71400068.filter2con,1,nil,tp)
end
function c71400068.get_zone(c,seq,self_linked_zone)
	local zone=self_linked_zone
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.replace(zone,0x1,seq+1) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.replace(zone,0x1,seq-1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,0) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,4) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,3) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,2) end
	return zone
end
function c71400068.filter2(c,e,tp,seq,self_linked_zone)
	local zone=c71400068.get_zone(c,seq,self_linked_zone)
	return zone~=0 and c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71400068.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local self_linked_zone=c:GetLinkedZone()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400068.filter2(chkc,e,tp,seq,self_linked_zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71400068.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,seq,self_linked_zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71400068.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,seq,self_linked_zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71400068.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local self_linked_zone=c:GetLinkedZone()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsRelateToEffect(e) then
		local zone=c71400068.get_zone(tc,c:GetSequence(),self_linked_zone)
		if zone~=0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end