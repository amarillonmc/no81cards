local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	--control & special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
function s.mfilter(c,xyzc)
	local tp=xyzc:GetControler()
	local lv=c:GetLevel()
	local olv=c:GetOriginalLevel()
	return c:IsXyzLevel(xyzc,10) or (c:IsControler(tp) and lv~=0 and lv~=olv and olv~=0)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		and e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetChainLimit(s.chlimit)
end
function s.xyzfilter(c,e,tp,mg,mc)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(mg)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp) then
		if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT) then
			c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			if og:GetCount()==2 and not og:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_MONSTER) then
				if tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then
					local sg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,og,tc)
					if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local sc=sg:Select(tp,1,1,nil):GetFirst()
						if sc then
							local mg=tc:GetOverlayGroup()
							if mg:GetCount()~=0 then
								Duel.Overlay(sc,mg)
							end
							sc:SetMaterial(Group.FromCards(tc))
							Duel.Overlay(sc,Group.FromCards(tc))
							Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
							sc:CompleteProcedure()
						end
					end
				end
			end
		end
	end
end