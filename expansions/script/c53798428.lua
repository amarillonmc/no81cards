local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.rfilter(c,e,tp)
	return c:IsCode(id+4) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function s.lv_func(c)
	return 8
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #mg>0 and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,s.rfilter,e,tp,mg,nil,s.lv_func,"Greater") end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	if #mg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,s.rfilter,e,tp,mg,nil,s.lv_func,"Greater")
	local tc=tg:GetFirst()
	if tc then
		-- 严格遵循仪式召唤素材的合法性过滤
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		
		-- 洗切额外卡组
		Duel.ShuffleExtra(tp)
		local seq=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)-1
		local mat=Group.CreateGroup()
		local sum=0
		-- 从上往下翻开，并使用标准仪式等级获取函数计算等级
		for i=seq,0,-1 do
			local c=Duel.GetFieldCard(tp,LOCATION_EXTRA,i)
			if c and c:IsFacedown() then
				mat:AddCard(c)
				-- 兼容性核心：使用仪式召唤专用的等级计算函数，而非普通的GetLevel
				sum = sum + aux.RitualCheckAdditionalLevel(c,tc)
				if sum>=8 then break end
			end
		end
		
		Duel.ConfirmCards(1-tp,mat)
		if sum>=8 then
			if Duel.Remove(mat,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				if #og>0 then
					local c=e:GetHandler()
					local oc=og:GetFirst()
					while oc do
						oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
						oc=og:GetNext()
					end
					og:KeepAlive()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					e1:SetLabelObject(og)
					e1:SetCountLimit(1)
					e1:SetCondition(s.retcon)
					e1:SetOperation(s.retop)
					Duel.RegisterEffect(e1,tp)
				end
				
				-- 兼容性核心：记录仪式素材并完成仪式召唤流程
				tc:SetMaterial(mat)
				-- （注：由于卡片文本要求直接除外，所以此处不调用Duel.ReleaseRitualMaterial）
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end
function s.retfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(s.retfilter,1,nil) and Duel.GetTurnPlayer()==1-tp
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.retfilter,nil)
	-- 额外卡组的卡返回时应洗回卡组
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	g:DeleteGroup()
end
function s.rmfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():IsSSetable()
		and Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsSSetable() then
			Duel.SSet(tp,c)
		end
	end
end

