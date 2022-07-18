--Attention: not fully implemented
local m=189109
local cm=_G["c"..m]
cm.name="方舟骑士-长夜临光"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0x1ff)
	e2:SetOperation(cm.op)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+m)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(115023,115039) and ((c:IsLocation(LOCATION_ONFIELD) and c:GetOriginalType()&TYPE_MONSTER~=0) or c:IsType(TYPE_PENDULUM))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil)
end
function cm.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(m)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	_G["aux"].RitualUltimateFilter=function(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
		if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
		local sbchk1,sbchk2,sbchk3,sbchk4=false,false,false,true
		if m2 then
			local chk1,chk2=false,false
			for m2c in aux.Next(m2) do
				if m2c:IsLocation(LOCATION_DECK) then chk1=true end
				if m2c:IsLocation(LOCATION_EXTRA) then chk2=true end
			end
			mg:Merge(m2)
			sbchk1=chk1 and chk2
			sbchk2=chk1 and not chk2
			sbchk3=chk2 and not chk1
			sbchk4=not chk1 and not chk2
		end
		local extraf=function(c)return false end
		if c:GetOriginalCode()==115043 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),189109) then
			extraf=function(c)return c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)end
			local m3=Duel.GetMatchingGroup(extraf,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
			mg:Merge(m3)
		end
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,c,tp)
		else
			mg:RemoveCard(c)
		end
		local lv=level_function(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
		local m3f=function(g,tp,c,lv,greater_or_equal,extraf,sbchk1,sbchk2,sbchk3,sbchk4)return aux.RitualCheck(g,tp,c,lv,greater_or_equal) and ((sbchk4 and g:FilterCount(extraf,nil)<=1) or (sbchk1 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=2 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2 and g:FilterCount(extraf,nil)<=3) or (sbchk2 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=2 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 and g:FilterCount(extraf,nil)<=2) or (sbchk3 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2 and g:FilterCount(extraf,nil)<=2))end
		local res=mg:CheckSubGroup(m3f,1,lv,tp,c,lv,greater_or_equal,extraf,sbchk1,sbchk2,sbchk3,sbchk4)
		aux.GCheckAdditional=nil
		return res
	end
	_G["aux"].RitualUltimateTarget=function(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local mg=Duel.GetRitualMaterial(tp)
			if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
			local exg=Group.CreateGroup()
			if grave_filter then
				exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
			end
			local extraf=function(c)return c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)end
			local exg2=Duel.GetMatchingGroup(extraf,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
			exg:Merge(exg2)
			local self=function(c,filter,e,tp,mg,exg,level_function,greater_or_equal,chk,exg2)return (c:GetOriginalCode()==115043 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),189109) and aux.RitualUltimateFilter(c,filter,e,tp,mg,exg,level_function,greater_or_equal,chk)) or (not (c:GetOriginalCode()==115043 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),189109)) and aux.RitualUltimateFilter(c,filter,e,tp,mg,Group.__sub(exg,exg2),level_function,greater_or_equal,chk))end
			return Duel.IsExistingMatchingCard(self,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true,exg2)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
		if grave_filter then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
		end
	end
	end
	_G["aux"].RitualUltimateOperation=function(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local mg=Duel.GetRitualMaterial(tp)
		if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
		local exg=Group.CreateGroup()
		if grave_filter then
			exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
		end
		local extraf=function(c)return c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)end
		local exg2=Duel.GetMatchingGroup(extraf,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		exg:Merge(exg2)
		local self=function(c,filter,e,tp,mg,exg,level_function,greater_or_equal,exg2)return (c:GetOriginalCode()==115043 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),189109) and aux.RitualUltimateFilter(c,filter,e,tp,mg,exg,level_function,greater_or_equal)) or (not (c:GetOriginalCode()==115043 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),189109)) and aux.RitualUltimateFilter(c,filter,e,tp,mg,Group.__sub(exg,exg2),level_function,greater_or_equal))end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,self,tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,exg2)
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,nil,tc)
			exg=Group.__sub(exg,exg2)
			if exg then
				mg:Merge(exg)
			end
			if exg2 and tc:GetOriginalCode()==115043 then
				mg:Merge(exg2)
			end
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local lv=level_function(tc)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,greater_or_equal)
			if tc:GetOriginalCode()==115043 then
				local m3f=function(g,tp,c,lv,greater_or_equal,extraf)return aux.RitualCheck(g,tp,c,lv,greater_or_equal) and g:FilterCount(extraf,nil)<=1 end
				local mat=mg:SelectSubGroup(tp,m3f,false,1,lv,tp,tc,lv,greater_or_equal,extraf)
				aux.GCheckAdditional=nil
				tc:SetMaterial(mat)
				local stg=mat:Filter(extraf,nil)
				mat:Sub(stg)
				if #stg>0 then Duel.SendtoGrave(stg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) end
				Duel.ReleaseRitualMaterial(mat)
			else
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
				aux.GCheckAdditional=nil
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
	end
	local all_cards=Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)
	local reg=Card.RegisterEffect
	Card.RegisterEffect=function(sc,se,bool)
		if sc:GetOriginalCode()==115045 then se:SetOperation(cm.nnop) end
		reg(sc,se,bool)
	end
	for tc in aux.Next(all_cards) do
		if tc.initial_effect then
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			cm.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	Card.RegisterEffect=reg
	e:Reset()
end
function cm.nnop(e,tp,eg,ep,ev,re,r,rp)
	local exf=function(c)return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGrave() and c:IsLocation(LOCATION_EXTRA)end
	local f=function(c)return c:GetOriginalCode()==115043 and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())end
	local mg=Duel.GetRitualMaterial(tp)
	local sg=nil
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
		sg=Duel.GetMatchingGroup(exf,tp,LOCATION_EXTRA,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,f,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		local extraf=function(c)return false end
		if Duel.IsPlayerAffectedByEffect(tp,189109) then
			extraf=function(c)return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)end
			local exg2=Duel.GetMatchingGroup(extraf,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
			if exg2 then mg:Merge(exg2) end
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local m3f=function(g,tp,c,lv,greater_or_equal,exf,extraf,sg)return aux.RitualCheck(g,tp,c,lv,greater_or_equal) and ((Duel.IsPlayerAffectedByEffect(tp,189109) and (sg and g:FilterCount(extraf,nil)<=2 and ((g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_DECK)==0 and g:Filter(extraf,nil):Filter(Card.IsLocation,nil,LOCATION_EXTRA):FilterCount(Card.IsFacedown,nil)<=1) or (g:Filter(extraf,nil):FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1 and g:Filter(extraf,nil):Filter(Card.IsLocation,nil,LOCATION_EXTRA):FilterCount(Card.IsFacedown,nil)==0))) or (not sg and g:FilterCount(extraf,nil)<=1)) or (not Duel.IsPlayerAffectedByEffect(tp,189109) and g:FilterCount(exf,nil)<=1)) end
		local mat=mg:SelectSubGroup(tp,m3f,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater",exf,extraf,sg)
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
