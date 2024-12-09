--OX ヴァイロン・セミシグマ
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
    --lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0x0c,0x0c)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
    --sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(0x04)
    e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(0x04)
    e2:SetCountLimit(1,m+1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.xyzcon)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(cm.effcon)
	e4:SetOperation(cm.effop)
	c:RegisterEffect(e4)
end

function cm.lvtg(e,c)
	return c:IsSetCard(0x30) and c:IsType(0x1400)
end

function cm.lvval(e,c,rc)
	if rc==e:GetHandler() then return 4 else return c:GetLevel() end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function cm.tgsfilter(c,tp)
    return c:IsType(0x1) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return #g>0 and g:IsExists(cm.tgsfilter,1,nil,tp) and Duel.GetLocationCount(tp,0x08)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0x04,0,1,nil) end
end

function cm.opsfilter(c,n)
	return c:GetFlagEffectLabel(m)==n
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local g=c:GetOverlayGroup():Filter(cm.tgsfilter,nil,tp)
		local ct=math.min(Duel.GetLocationCount(tp,0x08),g:GetCount())
		if ct>0 then
			local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0,nil)
			if #mg==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				g=g:Select(tp,1,ct,nil)
				if #g>0 then
					local mc=mg:GetFirst()
					for tc in aux.Next(g) do
						Duel.Equip(tp,tc,mc,false,true)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetLabelObject(mc)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						tc:RegisterEffect(e1)
					end
					Duel.EquipComplete()
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local ec=g:Select(tp,1,1,nil):GetFirst()
				local eqg,n=Group.CreateGroup(),0
				for i = 1, ct, 1 do
					g:RemoveCard(ec)
					eqg:AddCard(ec)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
					local mc=mg:Select(tp,1,1,nil):GetFirst()
					if mc:GetFlagEffect(m)==0 then
						mc:RegisterFlagEffect(m,0,0,1,n)
						ec:RegisterFlagEffect(m,RESET_EVENT+RESET_TOFIELD,0,1,n)
						n=n+1
					else
						ec:RegisterFlagEffect(m,RESET_EVENT+RESET_TOFIELD,0,1,mc:GetFlagEffectLabel(m))
					end
					if #eqg==ct then break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
					ec=g:Select(tp,0,1,nil):GetFirst()
					if not ec then break end
				end
				for tc in aux.Next(eqg) do
					local mc=mg:Filter(cm.opsfilter,nil,tc:GetFlagEffectLabel(m)):GetFirst()
					Duel.Equip(tp,tc,mc,false,true)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetLabelObject(mc)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(cm.eqlimit)
					tc:RegisterEffect(e1)
				end
				Duel.EquipComplete()
				for tc in aux.Next(mg) do
					tc:ResetFlagEffect(m)
				end
			end
		end
	end
end

function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end

function cm.tgxfilter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:CheckUniqueOnField(tp) and c:IsAbleToChangeControler()
end

function cm.tgxfilter2(c,e,tp,tc)
	return c:IsCode(39987164) and tc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end

function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(0x04) and cm.tgxfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgxfilter,tp,0,0x04,1,nil,tp) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
	and Duel.IsExistingMatchingCard(cm.tgxfilter2,tp,0x40,0,1,nil,e,tp,c) and Duel.GetLocationCount(tp,0x08)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.tgxfilter,tp,0,0x04,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.tgxfilter2,tp,0x40,0,1,1,nil,e,tp,c):GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
				sc:CompleteProcedure()
				local tc=Duel.GetFirstTarget()
				if tc:IsRelateToChain() then
					if tc:CheckUniqueOnField(tp) and tc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,0x08)>0 then
						Duel.Equip(tp,tc,sc)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetLabelObject(sc)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						tc:RegisterEffect(e1)
					else
						Duel.SendtoGrave(tc,REASON_RULE)
					end
				end
			end
		end
	end
end

function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsCode(39987164)
end

function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end