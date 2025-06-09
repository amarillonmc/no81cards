--学舌鹦鹉
local m=13000749
local cm=_G["c"..m]
function c13000749.initial_effect(c)
c:EnableReviveLimit()
	 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.chkfilter(c,i)
	return c:GetSequence()==i
end
function cm.rdfi0ter(c,e)
	return c:IsType(TYPE_RITUAL)
		and ((c:IsType(TYPE_MONSTER) and c:IsReleasable())
		or (c:IsType(TYPE_SPELL) and c:IsDestructable(e)))
end
function cm.fse2ect(g,tc)
	return g:IsContains(tc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if not g2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.GetMatchingGroup(cm.rdfi0ter,tp,0x0e,0,nil,e)
	if not g1 or not g1:IsContains(c) then return end
	local sg=g1:SelectSubGroup(tp,cm.fse2ect,false,1,#g1,c)
	local num=sg:GetCount()*3
	if num>#g2 then num=#g2 end
	Duel.SendtoGrave(sg,REASON_RELEASE)
	Duel.ConfirmDecktop(tp,num)
	Duel.ShuffleHand(tp)
	::cancel::
	local g=Duel.GetDecktopGroup(tp,num)
	local mg=Duel.GetRitualMaterial(tp)
	if not mg then mg=Group.CreateGroup() end
	local mg2=g:Filter(cm.filter4,nil)
	if mg2 then mg:Merge(mg2) end
	if mg:GetCount()>0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(cm.filter9,tp,LOCATION_HAND,0,nil,e,tp,mg)
		if not tg then tg=Group.CreateGroup() end
		local tg1=g:Filter(cm.filter9,nil,e,tp,mg)
		if tg1 then tg:Merge(tg1) end
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tg=tg:FilterSelect(tp,cm.suc,1,1,nil,mg,tp,e)
			if #tg~=0 then
				local tc=tg:GetFirst()
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.mat_filter then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg:RemoveCard(tc)
				end
				-- if not mg:CheckSubGroup(aux.RitualCheck,1,1,tp,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater") then
				--  return
				-- end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
				aux.GCheckAdditional=nil
				if not mat then
					aux.RCheckAdditional=nil
					aux.RGCheckAdditional=nil
					goto cancel
				end
				tc:SetMaterial(mat)
				local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
				if dmat:GetCount()>0 then
					mat:Sub(dmat)
					Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				end
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
	Duel.ShuffleDeck(tp)
end
function cm.suc(c,mg2,tp,e)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=mg2:Filter(Card.IsCanBeRitualMaterial,c,c)
	if not pcall(function()
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,c,tp)
		else
			mg:RemoveCard(c)
		end
	end) then
		mg:RemoveCard(c)
	end
	return mg:CheckSubGroup(aux.RitualCheck,1,1,tp,c,c:GetLevel(),"Greater")
end
function cm.hspgcheck(td,lv)   
	return td:CheckWithSumGreater(Card.GetLevel,lv)
end
function cm.filter9(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function cm.matfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.filter4(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end


function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	 if chk==0 then return not c:IsPublic() end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0
end
end
function cm.filter3(c)
	return not c:IsType(TYPE_RITUAL)
end
function cm.filter2(c)
	return c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(eg) do
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e0:SetValue(13000749)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e5)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e6)
	end
end